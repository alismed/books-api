import pytest
from unittest.mock import patch, MagicMock
from botocore.exceptions import ClientError
import app.src.main as main


@pytest.fixture(autouse=True)
def patch_table(monkeypatch):
    monkeypatch.setenv('DYNAMODB_TABLE', 'test-table')  # Set env var for all tests
    mock_table = MagicMock()
#    mock_table.name = 'table'  # Ensure 'name' attribute is always set
    monkeypatch.setattr(main, 'get_table', lambda: mock_table)
    return mock_table


def test_get_book_found(patch_table):
    patch_table.get_item.return_value = {'Item': {'book_id': '1', 'title': 'Test Book'}}
    response = main.get_book('1')
    assert response['statusCode'] == 200
    assert 'Test Book' in response['body']


def test_get_book_not_found(patch_table):
    patch_table.get_item.return_value = {}
    response = main.get_book('2')
    assert response['statusCode'] == 404
    assert 'not found' in response['body']


def test_get_book_client_error(patch_table):
    patch_table.get_item.side_effect = ClientError({'Error': {'Message': 'error'}}, 'get_item')
    response = main.get_book('3')
    assert response['statusCode'] == 500


def test_get_all_books_success(monkeypatch, patch_table):
    monkeypatch.setattr(main, 'recursive_scan', lambda params, items: [{'book_id': '1'}])
    response = main.get_all_books()
    assert response['statusCode'] == 200
    assert 'book_id' in response['body']


def test_get_all_books_client_error(patch_table):
    with patch('app.src.main.recursive_scan', side_effect=ClientError({'Error': {'Message': 'error'}}, 'scan')):
        response = main.get_all_books()
        assert response['statusCode'] == 500


def test_save_book_success(patch_table):
    patch_table.put_item.return_value = {}
    item = {'book_id': '1', 'title': 'Book'}
    response = main.save_book(item)
    assert response['statusCode'] == 201
    assert 'Book saved successfully' in response['body']


def test_save_book_client_error(patch_table):
    patch_table.put_item.side_effect = ClientError({'Error': {'Message': 'error'}}, 'put_item')
    item = {'book_id': '1'}
    response = main.save_book(item)
    assert response['statusCode'] == 500


def test_update_book_success(patch_table):
    patch_table.update_item.return_value = {'Attributes': {'title': 'New'}}
    response = main.update_book('1', 'title', 'New')
    assert response['statusCode'] == 200
    assert 'Book updated successfully' in response['body']


def test_update_book_not_found(patch_table):
    error = ClientError({'Error': {'Code': 'ConditionalCheckFailedException', 'Message': 'not found'}}, 'update_item')
    patch_table.update_item.side_effect = error
    response = main.update_book('2', 'title', 'New')
    assert response['statusCode'] == 404


def test_update_book_client_error(patch_table):
    error = ClientError({'Error': {'Code': 'Other', 'Message': 'error'}}, 'update_item')
    patch_table.update_item.side_effect = error
    response = main.update_book('3', 'title', 'New')
    assert response['statusCode'] == 500


def test_delete_book_success(patch_table):
    patch_table.delete_item.return_value = {'Attributes': {'book_id': '1'}}
    response = main.delete_book('1')
    assert response['statusCode'] == 200
    assert 'Book deleted successfully' in response['body']


def test_delete_book_not_found(patch_table):
    patch_table.delete_item.return_value = {}
    response = main.delete_book('2')
    assert response['statusCode'] == 404


def test_delete_book_client_error(patch_table):
    patch_table.delete_item.side_effect = ClientError({'Error': {'Message': 'error'}}, 'delete_item')
    response = main.delete_book('3')
    assert response['statusCode'] == 500
