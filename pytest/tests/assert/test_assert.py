import pytest
def f():
    return 3

def test_function():
    assert f() == 4

def test_odd_even_1():
    assert 3 % 2 == 0, "value was odd, should be even"

def test_odd_even_2():
    assert 4 % 2 == 0, "value was odd, should be even"

def test_zero_division():
    with pytest.raises(ZeroDivisionError):
        1 / 0

def test_recursion_depth():
    with pytest.raises(RuntimeError) as excinfo:
        def f():
            f()
        f()
    assert 'maximum recursion' in str(excinfo.value)

def myfunc():
    raise ValueError("Exception 123 raised")

def test_match():
	# Except Exception and assert True 
    with pytest.raises(ValueError, match=r'.* 123 .*'):
        myfunc()

def test_assert_exception():
	# Assert if the gieb Exception raises 
    pytest.raises(ValueError, myfunc())
