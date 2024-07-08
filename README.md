## Introduction

These files aim to help parse theorems that occurs in a theory file, transfer them into types that are compatible for GumTree parser tool (XML format)

## Structure

**MLs**: A folder that references the underlying ML files in the source code for Isabelle that helps to parse lemmas and convert them into a suitable format 

**converter.ML**: ML file that helps to convert theorems in a theory file into an XML format

**Test.thy**: Isabelle theory file that helps to implement the converter


## Usage

The functions `find_all_theorems`, `convert_Term` are our main interests
```
val find_all_theorems: theory -> (term * string) list;
```
The function takes a theory object (can be referenced in a theory file by the antiquotation `@{theory theory_name}`), and then return a list of tuples which consist of a `term`, the term (theorem) itself, and a `string`, which is the name of the term (theorem).
Example:
```
Converter.find_all_theorems @{theory Weight_Balanced_Trees}
```
This list can be access using the `List.nth` function in `Standard ML`
```
List.nth (list, index)
```

```
val convert_Term: Term.term -> string
```
The function takes a term object, and then convert it into a string (which is in XML format). The string can then be printed to another file for reusing by the GumTree parser tool
