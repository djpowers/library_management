# Edge Cases

## General

- errors saving records should be handle and a proper response code should be returned
- no authentication to endpoint

## Create Library

- the `name` attribute should likely be enforced to be unique at model and database levels
- returning "no content" by default, but could return newly created resource if needed

## Add Book to Library

- creation of book does not validate if ISBN and author/title match
