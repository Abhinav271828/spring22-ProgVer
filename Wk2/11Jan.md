---
title: Program Verification (CS1.303)
subtitle: |
          | Spring 2022, IIIT Hyderabad
          | 11 Jan, Tuesday (Lecture 3)
author: Taught by Atreya Ghosal
header-includes: \usepackage{mathpartir}
---

# Lean
In typed languages (like Haskell and C++, and unlike Racket), every expression has an associated type. A typed language can be statically or dynamically typed.  
Lean has an extremely rich type system.  

There are two types of statements in Lean – commands and expressions. An example of a command is
```lean
constant a : nat
```
where `nat` is the type of natural numbers. Other built-in types in Lean include `bool` and `Prop`.  

## Dependent Types
Dependent types are simply types that include values. For example, lists of length $n$ constitute a dependent type (as it includes the value $n$).
