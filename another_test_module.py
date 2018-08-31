from decorators import decorate_erl_string_args


@decorate_erl_string_args
def test_function(data):
    print("The data for another test module was: {}".format(data))
