#!/bin/bash
## Setup kumquat configuration

ALLOWED_HOST=$(hostname)
SECRET_KEY=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-100})

ADMIN_KUMQUAT=${ADMIN_KUMQUAT:-$(mdata-get kumquat_admin 2>/dev/null)} || \
ADMIN_KUMQUAT=$(od -An -N8 -x /dev/random | head -1 | tr -d ' ');
mdata-put kumquat_admin ${ADMIN_KUMQUAT}

CORE_MAIL_TOKEN=${CORE_MAIL_TOKEN:-$(mdata-get core_mail_token 2>/dev/null)} || \
CORE_MAIL_TOKEN=$(od -An -N8 -x /dev/random | head -1 | tr -d ' ');
mdata-put core_mail_token ${CORE_MAIL_TOKEN}

cat >> /opt/kumquat/kumquat_web/settings.py <<EOF
# Make this unique, and don't share it with anybody.
SECRET_KEY = "${SECRET_KEY}"

# Allow only the hostname and localhost to access
ALLOWED_HOSTS = ['127.0.0.1', 'localhost', '${ALLOWED_HOST}']

# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases
DATABASES = {
        'default': {
                'ENGINE':   'django.db.backends.sqlite3',
                'NAME':     '/var/sqlite/kumquat.sqlite3',
        },
}

# Kumquat
CORE_MAIL_TOKEN          = "${CORE_MAIL_TOKEN}"
EOF

# Init django data and create admin user
/opt/kumquat/manage.py syncdb --noinput

# Create superadmin user
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', '${ADMIN_KUMQUAT}')" \
	| /opt/kumquat/manage.py shell

# Be sure database permissions are correct
chown -R www:www /var/sqlite/
