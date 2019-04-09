def test_int():
    assert type(1) == type(int())

def test_int_xfail():
    assert type(str()) == type(int()) 
