from ansible import errors
try:
    from urllib.parse import quote  # Python 3
except ImportError:
    from urllib import quote  # Python 2

def urlquote(input_var):
    if input_var is None:
        raise errors.AnsibleFilterError('urlquote filter requires an input')

    # Convert Ansible-specific text types to standard string
    if not isinstance(input_var, str):
        input_var = str(input_var)

    # URL encode the string
    encoded_string = quote(input_var, safe='')

    # Double escape % for systemd
    return encoded_string.replace('%', '%%')

class FilterModule(object):
    ''' Ansible custom filter module for URL encoding strings '''
    def filters(self):
        return {
            'urlquote': urlquote
        }
