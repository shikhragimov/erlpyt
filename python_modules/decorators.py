import functools
import erlport


def decorate_erl_string_args(fn):
    """
    converts all args which are erl strings to python string
    :param fn: function
    :return: function result
    """
    @functools.wraps(fn)
    def wrapper(*args, **kwargs):
        args = [erlport.erlterms.List(arg).to_string().encode('raw_unicode_escape').decode('utf-8') for arg in args]
        return fn(*args, **kwargs)
    return wrapper

