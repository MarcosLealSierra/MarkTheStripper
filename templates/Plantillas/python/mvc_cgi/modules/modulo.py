#!/usr/bin/env python
# -*- coding: utf-8 -*-

from settings import HTTP_HTML


class Modulo(object):
    pass


class ModuloView(object):

    def vista(self):
        print HTTP_HTML
        print "Hola Mundo"


class ModuloController(object):
    
    def __init__(self):
        self.model = Modulo()
        self.view = ModuloView()
    
    def recurso(self):
        self.view.vista()
