import pytest
@pytest.mark.sanity
def test_sample():
    assert type(1) == type(int())
