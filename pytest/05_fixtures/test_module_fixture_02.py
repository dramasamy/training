# The name of the fixture again is smtp_connection and you can access its result by 
# listing the name smtp_connection as an input parameter in any test or fixture function
def test_ehlo(smtp_connection):
    response, msg = smtp_connection.ehlo()
    assert response == 250
    assert b"smtp.gmail.com" in msg
    assert 0  # for demo purposes


def test_noop(smtp_connection):
    response, msg = smtp_connection.noop()
    assert response == 250
    assert 0  # for demo purposes

# smtp.close() statements will execute when the last test in the module has finished
# execution, regardless of the exception status of the tests.
def test_noop_2(smtp_connection_finalization):
    response, msg = smtp_connection_finalization.noop()
    assert response == 250
    assert 0  # for demo purposes

def test_noop_100(smtp_connection_finalization):
    response, msg = smtp_connection_finalization.noop()
    assert response == 250
    assert 0  # for demo purposes

def test_noop_200(smtp_connection_finalization):
    response, msg = smtp_connection_finalization.noop()
    assert response == 250
    assert 0  # for demo purposes


def test_noop_3(smtp_connection_read_data_from_test):
    response, msg = smtp_connection_read_data_from_test.noop()
    assert response == 250
    assert 0  # for demo purposes


def test_noop_4(smtp_connection_parametrize):
    response, msg = smtp_connection_parametrize.noop()
    assert response == 250
    assert 0  # for demo purposes
