from python_modules.decorators import decorate_erl_string_args


@decorate_erl_string_args
def test_function(data):
    print("The data was: {}".format(data))
