import pytest
import smtplib

# Possible values for scope are: 
# 1. function
# 2. class
# 3. module
# 4. package
# 5. session

@pytest.fixture
def smtp_connection():
    return smtplib.SMTP("smtp.gmail.com", 587, timeout=5)

# Fixtures as Function arguments
# Test functions can receive fixture objects by naming them as an input argument. 
# For each argument name, a fixture function with that name provides the fixture object.
# Fixture functions are registered by marking them with @pytest.fixture. Let’s look at
# a simple self-contained test module containing a fixture and a test function using it
def test_ehlo(smtp_connection):
"""
1. pytest finds the test_ehlo because of the test_ prefix. The test function needs a function 
argument named smtp_connection. A matching fixture function is discovered by looking for a 
fixture-marked function named smtp_connection.
2. smtp_connection() is called to create an instance.
3. test_ehlo(<smtp_connection instance>) is called and fails in the last line of the test function.
"""
    response, msg = smtp_connection.ehlo()
    assert response == 250
    assert 0 # for demo purposes





@pytest.fixture(scope="session")
def s1():
    pass


@pytest.fixture(scope="module")
def m1():
    pass


@pytest.fixture
def f1(tmpdir):
    pass


@pytest.fixture
def f2():
    pass


def test_foo(f1, m1, f2, s1):
"""
The fixtures requested by test_foo will be instantiated in the following order:

s1: is the highest-scoped fixture (session).
m1: is the second highest-scoped fixture (module).
    tmpdir: is a function-scoped fixture, required by f1: it needs to be instantiated 
    at this point because it is a dependency of f1.
f1: is the first function-scoped fixture in test_foo parameter list.
f2: is the last function-scoped fixture in test_foo parameter list.
"""
    assert 0