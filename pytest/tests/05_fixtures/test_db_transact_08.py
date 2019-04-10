# Autouse fixtures (xUnit setup on steroids)¶
# Occasionally, you may want to have fixtures get invoked automatically without declaring 
# a function argument explicitly or a usefixtures decorator. As a practical example, suppose 
# we have a database fixture which has a begin/rollback/commit architecture and we want to 
# automatically surround each test method by a transaction and a rollback. Here is a dummy 
# self-contained implementation of this idea:
import pytest

class DB(object):
    def __init__(self):
        self.intransaction = []
    def begin(self, name):
        self.intransaction.append(name)
    def rollback(self):
        self.intransaction.pop()

@pytest.fixture(scope="module")
def db():
    return DB()

class TestClass(object):
    @pytest.fixture(autouse=True)
    def transact(self, request, db):
        db.begin(request.function.__name__)
        yield
        db.rollback()

    # The class-level transact fixture is marked with autouse=true which implies that 
    # all test methods in the class will use this fixture without a need to state it 
    # in the test function signature or with a class-level usefixtures decorator.
    def test_method1(self, db):
        assert db.intransaction == ["test_method1"]

    def test_method2(self, db):
        assert db.intransaction == ["test_method2"]