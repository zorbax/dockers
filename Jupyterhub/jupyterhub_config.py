# jupyterhub_config.py
c = get_config()

# Change from JupyterHub to JupyterLab
c.Spawner.default_url = '/lab'
c.Spawner.debug = True

# Administrators - set of users who can administer the Hub itself
c.Authenticator.admin_users = {'atgenomics'}
c.LocalAuthenticator.create_system_users=True 
