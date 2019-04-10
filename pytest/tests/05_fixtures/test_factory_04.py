import pytest

@pytest.fixture
def make_customer_record():

    def _make_customer_record(name):
        return {
            "name": name,
            "orders": []
        }

    return _make_customer_record


# The “factory as fixture” pattern can help in situations where the result of a fixture
# is needed multiple times in a single test. Instead of returning data directly, the 
# fixture instead returns a function which generates the data. This function can then 
# be called multiple times in the test.
def test_customer_records(make_customer_record):
    customer_1 = make_customer_record("Lisa")
    customer_2 = make_customer_record("Mike")
    customer_3 = make_customer_record("Meredith")
    print(customer_1)
    print(customer_2)
    print(customer_3)