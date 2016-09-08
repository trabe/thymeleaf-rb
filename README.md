# Thymeleaf.rb

[![Build Status](https://travis-ci.org/trabe/thymeleaf-rb.svg)](https://travis-ci.org/trabe/thymeleaf-rb)

Thymeleaf.rb is a Ruby adaptation of [Thymeleaf](http://www.thymeleaf.org), a natural templating engine.

It allows to create natural templates (HTML that can be correctly displayed in browsers and also work as static prototypes) and render with a data set to provide them functionality.

**This is a Work In Progress Project. This gem is not ready for production use**

A Thymeleaf.rb template looks like:

```html
<table>
  <thead>
    <tr>
      <th data-th-text="${headers.name}">Name</th>
      <th data-th-text="${headers.price}">Price</th>
    </tr>
  </thead>
  <tbody>
    <tr data-th-each="prod : ${all_products}">
      <td data-th-text="${prod.name}">Oranges</td>
      <td data-th-text="${prod.price}">0.99</td>
    </tr>
  </tbody>
</table>
```


## Installation

Add the gem to your `Gemfile`:

```shell
gem install thymeleaf
```

and then execute:
```shell
$ bundle
```

Or install it yourself as:
```shell
$ gem install thymeleaf
```


## Usage

To use a template, simply:

```ruby
Thymeleaf::Template.new(template_content, context).render
```

Where `template_content` is the template as HTML code and `context` is a hash with template values.

You can also specify a file:

```ruby
Thymeleaf::Template.new('path/to/template', context).render_file
```

## Simple example


```ruby
Thymeleaf::Template.new('<p data-th-text="Hello, ${user}">Hello, world</p>', { :user => 'John' }).render
```

The parsed result of the above:

```html
<p>Hello, John</p>
```

## Configuration

Thymeleaf.rb offers quite a few options through the `Configure` module:

```ruby
Thymeleaf.configure do |config|
  # Template prefix. Used in render_file method and include/replace
  config.template.prefix = "path/to/my/templates/"
  
  # Template suffix. Used in render_file method and include/replace
  config.template.suffix = '.th.html'
  
  # Changes encoding from UTF-8 (default) to 'EUC-JP'
  config.parser.encoding='EUC-JP'
end
```

The `config` var is an instance of `Configuration`, which has some methods to configure the engine:

- `template.prefix=''`: specify a template prefix. Used in `render_file` method and include/replace processors.
- `template.suffix=''`: specify a template suffix. Used in `render_file` method and include/replace processors.
- `config.parser.encoding=''`: overwrites the default document encoding (UTF-8). 
- `add_dialect(Dialect)`: registers a dialect into the engine.
- `clear_dialects`: clears all registered dialects (including standard dialect).


### Context

Context sent to the engine can be:

- A *hash* dictionary with the variables you want to be accessibles within the template.
- An `OpenStruct` class.

Context values can be any kind of data. Thymeleaf.rb converts the passed context to a class similar to `OpenStruct`, so the limitations about the identifiers are the same as it.


## Default dialect

**Default Dialect** is included by default in Thymeleaf.rb, and offers a set of processors and utilities to render templates.

Default dialect's attributes have the `data-th-` preffix (which is HTML5 friendly), so any attribute starting with it will be processed:

```html
<h1 data-th-if="${true_var}" data-th-text="Welcome, user">Greetings</h1>
```

The result of the above:

```html
<h1>Welcome, user</h1>
```

## General syntax

Default Dialect supports some syntax variants as attribute values:

- **Literals**, which is any text value:
```text
"3 + 2" - Output: "3 + 2"
```
- **Expression evaluator**, which is an evaluable Ruby expression inside `${` and `}` symbols which includes context vars access: 
```text
"${3 + 2}" - Output: "5"
```
- **Selector evaluator**, which evaluates a method or property of a previous defined variable:
```text
"*{name}" - instead of ${user.name})
```

These values can be used together inside an attribute value:
```html
<div data-th-text="*{name} is ${20 + 5} years old"></div>
```

# Basic attributes
## Text

Node content can be overwritten with `data-th-text` attribute:

```html
<p data-th-text="${surname}, ${name}"></p>
```

If we need text won't be escaped can use the `data-th-utext` variant:
```html
<pre data-th-text="${unescaped_text}"></pre>
 ```

Please, *be careful* when using unescaped text from the end-user.

### Conditionals

#### `if` conditional
Conditionals allows you to show or delete a node by evaluating a variable:

```html
<div data-th-if="${true_var}">Hi, baby</p>
<div data-th-if="${false_var}">I'll not be shown after Thymeleaf processed me :(</p>
```

#### `unless` conditional

There is the `until` conditional too:

```html
<div data-th-unless="${true_var}">Hi, baby</p>
<div data-th-unless="${false_var}">Revenge is a dish best served cold &gt;:)</p>
```

#### `switch-case` statement

`switch-case` works as it expected:

```html
<div data-th-switch="${user.role}">
    <p data-th-case="admin">Admin user</p>
    <p data-th-case="manager">Manager user</p>
</div>
```

There are two notes about it:
- All `case` tags are evaluated, independent of a previous tag was matched.
- There is not a default `case`.

#### Boolean evaluation

Evaluation of conditional attributes to true/false values is done by applying the following rule:
an evaluation is `true` unless its string value is one of these words (case insensitive):
- false
- f
- nil
- no
- n
- 0
- -0

### `each` iterator

`each` iterator accepts an iterable element as parameter (list, set...) and repeats the node fragment for each element.

```html
<table>
  <tr>
    <th>NAME</th>
    <th>PRICE</th>
  </tr>
  <tr data-th-each="prod : ${prods}">
    <td data-th-text="${prod.name}">Onions</td>
    <td data-th-text="${prod.price}">2.41</td>
  </tr>
</table>
```

In the fragment above:

- `${prods}` is the iterated expression or iterated variable.
- `prod` is the iteration variable.

Note that the `prod` variable will only be available inside the `<tr>` element (including inner tags like `<td>`).

#### Iteration status

There is an alternative syntax for `each`:

```html
<table>
  <tr>
    <th>NAME</th>
    <th>PRICE</th>
  </tr>
  <tr data-th-each="prod, stat : ${prods}">
    <td data-th-text="${prod.name}">Onions</td>
    <td data-th-text="${prod.price}">2.41</td>
  </tr>
</table>
```


Where `stat` is a status variable defined within a `data-th-each` attribute that contain the following data:

- `index`: the current iteration index, starting with 0.
- `count`: current iteration index, starting with 1.
- `size`: the total amount of elements in the iterated variable..
- `current`: The iter variable for each iteration.
- `even`: `true` whether the current iteration is even or `false` if not.
- `odd` `true` whether the current iteration is even or `false` if not.
- `first`: `true` whether the current iteration is the first one or `false` if not.
- `last`: `true` whether the current iteration is the last one or `false` if not.

Since status variable contains the iteration variable value, we can rewrite the previous example:

```html
<table>
  <tr>
    <th>NAME</th>
    <th>PRICE</th>
  </tr>
  <tr data-th-each="_, stat : ${prods}">
    <td data-th-text="${stat.current.name}">Onions</td>
    <td data-th-text="${stat.current.price}">2.41</td>
  </tr>
</table>
```

### Remove

The `data-th-remove` attribute allows to delete document nodes:

```html
<table>
  <tr>
    <th>NAME</th>
    <th>PRICE</th>
  </tr>
  <tr data-th-each="_, stat : ${prods}">
    <td data-th-text="${stat.current.name}">Onions</td>
    <td data-th-text="${stat.current.price}">2.41</td>
  </tr>
  <tr class="odd" data-th-remove="all">
    <td>Blue Lettuce</td>
    <td>9.55</td>
  </tr>
  <tr data-th-remove="all">
    <td>Mild Cinnamon</td>
    <td>1.99</td>
  </tr>
</table>
```

`data-th-remove` can behave in different ways, depending on its value:

- `all`: Remove both the containing tag and all its children.
- `body`: Do not remove the containing tag, but remove all its children.
- `tag`: Remove the containing tag, but do not remove its children.
- `all-but-first`: Remove all children of the containing tag except the first one. It will let us save some `data-th-remove="all"` when prototyping.
- `none`: Do nothing. This value is useful for dynamic evaluation.


### Object

We can assign a value to be used as the context value of *selection operator* with the `data-th-object` attribute as follow:

```html
<div data-th-block="${user}">
    <h1 data-th-text="Hello, *{name}">Greetings</h1>
    ...
</div>
```

Which is a shorted way to write:
```html
<div>
    <h1 data-th-text="Hello, ${user.name}">Greetings</h1>
    ...
</div>
```


### Fragments

Fragment expressions are an easy way to represent fragments of markup and move them around templates. This allows to replicate them, pass them to other templates as arguments, etc.

Fragments are defined by `data-th-fragment` attribute:

```html
<footer data-th-fragment="myfooter">
    <span data-th-text="Copyright ${date.year} Trabe">
        Copyright 2016 My Company
    </span>
</footer>
```

#### Include and replace

`data-th-include` and `data-th-replace` are used to insert:
 
 - Other templates into the current one.
 - Other fragments of the current template.
 - Fragments of other templates.
 
 Their syntax is as follow:
 ```ruby
 template :: fragment
 ```
 
 Where `template` is the name of template to include and `fragment` is the name of declared fragment (with `data-th-fragment`) inside the previous template. To indicate the current template, you can use the `this` identificator. When any option is not required, it can be omitted:
 
 - `template` or `template ::` to insert a template
 - `::fragment` to insert any current template fragment. It is equivalent to `this::fragment`.

 For example, to include the `myfooter` fragment from the previous example defined in the same template:
 ```html
<div data-th-insert="myfooter">...</div>
 <!-- Or... -->
 <div data-th-insert="this::myfooter">...</div>
 ```
 
 The difference between `data-th-include` and `data-th-replace` is, while `include` inserts the fragment or template inside the container node, `replace` replaces the container node:
 
 ```html
<div data-th-insert="myfooter" class="inserted">...</div>
<div data-th-replace="myfooter" class="replaced">...</div>
 ```
 
 The result of the above:
 ```html
 <div class="inserted">
     <footer>
     <span>Copyright 2016 Trabe</span>
   </footer>
 </div>
 <footer>
   <span>Copyright 2016 Trabe</span>
 </footer>
 ```

##### DOM selector

Fragment inclusion can be done by CSS selector, instead of fragments definition. For example, we can insert the tag with `id="footerid"` with:
```html
<div data-th-insert="#footerid" class="inserted">...</div>
```

We can insert all divs on a document, too:
```html
<footer data-th-insert="div" class="inserted">...</footer>
```

Basically, when a fragment is invoked in a `data-th-include` or `data-th-replace` attribute, Thymeleaf.rb searchs first for any declared fragment with `data-th-fragment` and, if there is not any result, searchs on document by CSS selector.


## Contributing and help

If you'd like to help improve Thymeleaf.rb, feel free to submit a pull request. If you found something we should know about, please submit an issue.

## License

Thymeleaf.rb is released under the MIT license.