import pytest

from pyjenk.calculator import add


def test_add():
    result = add(3, 5)
    assert result == 8


def test_add_zero():
    result = add(3, 0)
    assert result == 3


def test_add_string():
    with pytest.raises(TypeError):
        add("string", 4)
