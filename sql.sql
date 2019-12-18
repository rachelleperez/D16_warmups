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


-- Answer - with Translate and individual characters

WITH cleaned_product_names AS (
	SELECT productname,
		TRANSLATE(product
        name, 
		'ßàáâãäéèëêíìïîóòõöôúùüûçÇ''-', 
		'Saaaaaeeeeiiiiooooouuuucc') as cleaned
FROM products)
SELECT *,
	REPLACE(INITCAP(cleaned), ' ', '')::VARCHAR(11)
FROM cleaned_product_names;

-- NOTES

-- translate(column, string with characters_to_replace, replacement_character): enter column, what CHARACTER to look for, and what CHARACTER to replace it with
-- NOTE1 = a single quotatation within the string with characters to replace MUST be represented in double quotations
-- NOTE2 = Translate replaces characters one by one from left to right. Any extra characters to replace that do not have a match get remoced
-- replace (column, string_to_replace, string_character): enter column, what whole string to look for, and what string to replace it with
-- initcap(column): first letter capital, rest lower case

-- REPLACE(): Replaces all occurrences of a specified string value with another string value.
-- TRANSLATE(): Returns the string provided as a first argument after some characters specified in the second argument are translated into a destination set of characters.
-- 

---------------------------------------------------------------------


-- v.2 - works, but what is it doing exactly? 
-- removes the first space, changed some characters, nade only the first letter capital? 

SELECT ProductName,INITCAP(regexp_replace(ProductName, '[^\w]+',''))
FROM Products
ORDER BY ProductName;

-- v2. returns

            productname            |             initcap
-----------------------------------+----------------------------------
 Alice Mutton                      | Alicemutton
 Aniseed Syrup                     | Aniseedsyrup
 Boston Crab Meat                  | Bostoncrab Meat
 C├â┬┤te de Blaye                    | C├úte De Blaye
 Camembert Pierrot                 | Camembertpierrot
 Carnarvon Tigers                  | Carnarvontigers
 Chai                              | Chai
 Chang                             | Chang
 Chartreuse verte                  | Chartreuseverte
...

/*
Regex_replace - What does each part do?

metacharacter: dot (.)
bracket list: [ ]
position anchors: ^, $
occurrence indicators: +, *, ?, { }
parentheses: ( )
or: |
escape and metacharacter: backslash (\)



'[^\w]+',''

' ' = the regular expression is wrapped in single quotes.
\ = prepend to characters to match (e.g. \a matches "a")
w =  "word character": inclusion of the underscore, digits, etc.
\w = Find a word character
^ negates
^\w = non word character ( same as \W)
[] = range (eg [abc] = find any character within the brackets. [^abd] = find any character NOT within the brackets)
[^\w] = find any individual non word character
+ = at least 1 of the preceding. 
[^\w]+ = find any combination of at least 1 non word character

---------------------------------------

 What is a WORD CHARACTER - From Stack Overflow

\w matches any word character. A word character is a member of any of the Unicode categories listed in the following table.

Ll (Letter, Lowercase)
Lu (Letter, Uppercase)
Lt (Letter, Titlecase)
Lo (Letter, Other)
Lm (Letter, Modifier)
Nd (Number, Decimal Digit)
Pc (Punctuation, Connector)
This category includes ten characters, the most commonly used of which is the LOWLINE character (_), u+005F.

Basically it matches everything that can be considered the intuitive definition of letter in various scripts – plus the underscore and a few other oddballs.

From W3Schools

A word character is a character from a-z, A-Z, 0-9, including the _ (underscore) character.

*/

