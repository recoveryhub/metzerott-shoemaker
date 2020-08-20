---
title: the example
products:
 - top-level: Product One
   arbitrary: Value
   nested-products:
    - nested: Associated Product
      sub-arbitrary: Associated Value
    - nested: Another associate
      sub-arbitrary: with its associated value
 - top-level: Product Two
   arbitrary: Value
   nested-products:
    - nested: nested product Two
      sub-arbitrary: Two's nested's associate value
 - top-level: Product Three
   arbitrary: Value
 - top-level: Product Four
   arbitrary: SomeValue

title: Metzerott, Shoemaker
author: Katherine Pearson Woods
editor: 
  - name: Jean Lee Cole
---

<!-- index.html -->
<!DOCTYPE html>
<html lang="en">

<head>
  <title>{{ page.title }}</title>
</head>

<body>

<h4>products:</h4>
<ul>{% for product in page.products %}
  <li>{{ product.top-level }}: {{ product.arbitrary }}{% if product.nested-products %}
    <ul>
    {% for nestedproduct in product.nested-products %}  <li>{{ nestedproduct.nested }}: {{ nestedproduct.sub-arbitrary }}</li>
    {% endfor %}</ul>
  {% endif %}</li>{% endfor %}
</ul>

<h2>{{ page.editor.editor_name }} test</h2>

<h2>
  {% for edit in page.editor %}
    {{ edit.name }}
  {% endfor %}

</h2>

</body>
</html>