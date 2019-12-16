-- We're going to produce unique labels for our products to be printed off on reciepts and shipping labels.
-- The Rule for this label (using product_name):
-- all special characters should be removed/replaced with standard characters (eg. cöté -> cote, 's -> s)
-- The first letter of every word needs to be capitalized
-- no spaces between words
-- max of 11 characters total

-- keywords to google: translate, initcap, replace, regex_replace
-- also play around with the examples here: 
-- https://stackoverflow.com/questions/4428645/postgres-regexp-replace-want-to-allow-only-a-z-and-a-z

-- GOALS: 

-- 1) remove special characters
-- 2) capitalize first letter (INITCAP)
-- 3) no spaces

-- v.1 - works, but what is it doing exactly? 

SELECT ProductName,INITCAP(regexp_replace(ProductName, '[^\w]+',''))
FROM Products
ORDER BY ProductName;

-- v.2 - in progress 

SELECT ProductName,INITCAP(regexp_replace(ProductName, '[...+|_',''))
FROM Products
ORDER BY ProductName;

-- NOTES

-- translate(column, string_to_replace, replacement_string): enter column, what to look for, and what to replace
-- initcap(column): first letter capital, rest lower case

-- REPLACE(): Replaces all occurrences of a specified string value with another string value.
-- TRANSLATE(): Returns the string provided as a first argument after some characters specified in the second argument are translated into a destination set of characters.
-- 

f you want to also include the _ to be replaced (\w will leave it) you can change the regex to [^\w]+|_.

[]
^ = matching 
| = or
... = any one of the characters
\w - Any word