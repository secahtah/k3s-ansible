def colon_format(value):
    return ':'.join(value[i:i+2] for i in range(0, len(value), 2))

class FilterModule(object):
    def filters(self):
        return {
            'colon_format': colon_format
        }
