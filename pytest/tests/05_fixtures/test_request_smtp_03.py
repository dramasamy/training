smtpserver = "mail.python.org"  # will be read by smtp fixture

def test_showhelo1(smtp_connection_read_data_from_test):
    assert 0, smtp_connection_read_data_from_test.helo()