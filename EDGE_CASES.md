# Edge Cases

## General

- errors saving records should be handle and a proper response code should be returned

## Create Library

- the `name` attribute should likely be enforced to be unique at model and database levels
- returning "no content" by default, but could return newly created resource if needed
