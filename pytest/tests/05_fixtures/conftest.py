import pytest
import smtplib
import tempfile
import os

# Fixtures requiring network access depend on connectivity and are usually time-expensive to create.
# Extending the previous example, we can add a scope="module" parameter to the @pytest.fixture
# invocation to cause the decorated smtp_connection fixture function to only be invoked once per
# test module (the default is to invoke once per test function). Multiple test functions in a test
# module will thus each receive the same smtp_connection fixture instance, thus saving time.
@pytest.fixture(scope="module")
def smtp_connection():
    return smtplib.SMTP("smtp.gmail.com", 587, timeout=5)


@pytest.fixture(scope="module")
def smtp_connection_finalization():
    smtp_connection = smtplib.SMTP("smtp.gmail.com", 587, timeout=5)
    yield smtp_connection  # provide the fixture value
    print("teardown smtp")
    smtp_connection.close()


@pytest.fixture(scope="module")
def smtp_connection_read_data_from_test(request):
    server = getattr(request.module, "smtpserver", "smtp.gmail.com")
    smtp_connection = smtplib.SMTP(server, 587, timeout=5)
    yield smtp_connection
    print("finalizing %s (%s)" % (smtp_connection, server))
    smtp_connection.close()


@pytest.fixture(scope="module",
                params=["smtp.gmail.com", "mail.python.org"])
def smtp_connection_parametrize(request):
    smtp_connection = smtplib.SMTP(request.param, 587, timeout=5)
    yield smtp_connection
    print("finalizing %s" % smtp_connection)
    smtp_connection.close()


@pytest.fixture()
def cleandir():
    newpath = tempfile.mkdtemp()
    os.chdir(newpath)