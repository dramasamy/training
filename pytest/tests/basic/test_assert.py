def odd_even(a):
    assert a % 2 == 0, "value was odd, should be even"

def test_odd_even_1():
    odd_even(1)

def test_odd_even_2():
    odd_even(2)
