-- Consultar una tabla completa
SQL
SELECT * FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Consultar campos seleccionados de la tabla
SQL
SELECT Name, StandardCost, ListPrice
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Incluir una expresión que dé como resultado una columna calculada y luego vuelva a ejecutar la consulta:
-- Tenga en cuenta que esta vez los resultados incluyen la columna Nombre y una columna sin nombre que 
-- contiene el resultado de restar StandardCost de ListPrice .
SQL
SELECT Name, ListPrice - StandardCost
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Asignar nombres a las columnas en los resultados y luego vuelva a ejecutar la consulta.
-- Tenga en cuenta que los resultados ahora incluyen columnas denominadas ProductName y Markup. 
-- La palabra clave AS se ha utilizado para asignar un alias para cada columna de los resultados.
SQL
SELECT Name AS ProductName, ListPrice - StandardCost AS Markup
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Expresión concatenar que genera una columna calculada en los resultados:
-- Tenga en cuenta que los resultados ahora incluyen columnas denominadas ProductName y Markup . 
-- La palabra clave AS se ha utilizado para asignar un alias para cada columna de los resultados.
-- NOTA!!!!!!!!!!!!!
-- Ejecute la consulta y tenga en cuenta que el operador + en la columna ProductDetails calculada se 
-- utiliza para concatenar los valores de las columnas Color y Tamaño (con una coma literal entre ellos). 
-- El comportamiento de este operador está determinado por los tipos de datos de las columnas: si hubieran 
-- sido valores numéricos, el operador + los habría agregado . Tenga en cuenta también que algunos resultados 
-- son NULL ; exploraremos los valores NULL más adelante en esta práctica de laboratorio.
SQL
SELECT ProductNumber, Color, Size, Color + ', ' + Size AS ProductDetails
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Trabajar con tipos de datos
-- Como acaba de ver, las columnas de una tabla se definen como tipos de datos específicos, 
-- lo que afecta las operaciones que puede realizar en ellas.
-- NOTA !!!!!!!!!!!!
-- Tenga en cuenta que esta consulta devuelve un error. El operador + se puede utilizar para concatenar valores 
-- basados ​​en texto o agregar valores numéricos; pero en este caso hay un valor numérico ( ProductID ) y un valor 
-- basado en texto ( Name ), por lo que no está claro cómo se debe aplicar el operador.
SQL
SELECT ProductID + ': ' + Name AS ProductName
FROM SalesLT.Product; 
-- ----------------------------------------------------------------------------------------------------------------
-- Conversion de enteros a alfanumericos
-- Tenga en cuenta que el efecto de la función CAST es cambiar la columna numérica ProductID a un valor varchar 
-- (datos de caracteres de longitud variable) que se puede concatenar con otros valores basados ​​en texto.
SQL
SELECT CAST(ProductID AS varchar(5)) + ': ' + Name AS ProductName
FROM SalesLT.Product; 
-- ----------------------------------------------------------------------------------------------------------------
-- Modifique la consulta para reemplazar la función CAST con una función CONVERT como se muestra a continuación
-- NOTA!!!!!!!!!!
-- Tenga en cuenta que los resultados del uso de CONVERT son los mismos que para CAST . La función CAST es una 
-- parte estándar ANSI del lenguaje SQL que está disponible en la mayoría de los sistemas de bases de datos, mientras 
-- que CONVERT es una función específica de SQL Server.
SQL
SELECT CONVERT(varchar(5), ProductID) + ': ' + Name AS ProductName
FROM SalesLT.Product; 
-- ----------------------------------------------------------------------------------------------------------------
-- Otra diferencia clave entre las dos funciones es que CONVERTIR incluye un parámetro adicional que puede ser útil 
-- para formatear valores de fecha y hora al convertirlos a datos basados ​​en texto. Por ejemplo, reemplace la consulta 
-- existente con el siguiente código y ejecútela.
SQL
SELECT SellStartDate,
   CONVERT(nvarchar(30), SellStartDate) AS ConvertedDate,
    CONVERT(nvarchar(30), SellStartDate, 126) AS ISO8601FormatDate
FROM SalesLT.Product; 
-- ----------------------------------------------------------------------------------------------------------------
-- Reemplace la consulta existente con el siguiente código y ejecútela.
-- Tenga en cuenta que se devuelve un error porque algunos valores de Tamaño no son numéricos (por ejemplo, algunos 
-- tamaños de artículos se indican como S , M o L ).
SQL
SELECT Name, CAST(Size AS Integer) AS NumericSize
FROM SalesLT.Product; 
-- ----------------------------------------------------------------------------------------------------------------
-- Correccion de error en la consulta para utilizar una función TRY_CAST , como se muestra aquí.
SQL
SELECT Name, TRY_CAST(Size AS Integer) AS NumericSize
FROM SalesLT.Product; 
-- ----------------------------------------------------------------------------------------------------------------
-- Manejar valores NULL
-- Ejecute la consulta y observe que los valores numéricos de Tamaño se convierten correctamente a números enteros, 
-- pero que los tamaños no numéricos se devuelven como NULL .
-- NOTA!!!!!!!!!!!
-- Hemos visto algunos ejemplos de consultas que devuelven valores NULL . NULL se utiliza generalmente para indicar 
-- un valor desconocido . Tenga en cuenta que esto no es lo mismo que decir que el valor es ninguno ; eso implicaría 
-- que sabe que el valor es cero o una cadena vacía.
SQL
SELECT Name, ISNULL(TRY_CAST(Size AS Integer),0) AS NumericSize
FROM SalesLT.Product;
-- Ejecute la consulta y vea los resultados. Tenga en cuenta que la función ISNULL reemplaza los valores NULL con 
-- el valor especificado, por lo que en este caso, los tamaños que no son numéricos (y por lo tanto no se pueden 
-- convertir a enteros) se devuelven como 0 .
-- En este ejemplo, la función ISNULL se aplica a la salida de la función TRY_CAST interna , pero también puede 
-- usarla para manejar valores NULL en la tabla de origen.
-- ----------------------------------------------------------------------------------------------------------------
-- Manejar valores NULL para los valores de Color y Tamaño en la tabla de origen:
-- La función ISNULL reemplaza los valores NULL con un valor literal especificado. A veces, es posible que desees 
-- lograr el resultado opuesto reemplazando un valor explícito con NULL . Para hacer esto, puede usar la función NULLLIF.
SQL
SELECT ProductNumber, ISNULL(Color, '') + ', ' + ISNULL(Size, '') AS ProductDetails
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Pruebe la siguiente consulta, que reemplaza el valor de Color "Multi" por NULL .
SQL
SELECT Name, NULLIF(Color, 'Multi') AS SingleColor
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Encontrar la primera fecha no NULL para el estado de venta del producto.
SQL
SELECT Name, COALESCE(SellEndDate, SellStartDate) AS StatusLastUpdated
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- La expresión CASE debe determinar si la columna SellEndDate es NULL.
-- Ejecute la siguiente consulta, que incluye CASE buscado que utiliza una expresión IS NULL para verificar valores 
-- NULL SellEndDate .
SQL
SELECT Name,
    CASE
        WHEN SellEndDate IS NULL THEN 'Currently for sale'
        ELSE 'No longer available'
    END AS SalesStatus
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Expresión CASE simple que produjo resultados diferentes según el valor de la columna Tamaño .
SQL
SELECT Name,
    CASE Size
        WHEN 'S' THEN 'Small'
        WHEN 'M' THEN 'Medium'
        WHEN 'L' THEN 'Large'
        WHEN 'XL' THEN 'Extra-Large'
        ELSE ISNULL(Size, 'n/a')
    END AS ProductSize
FROM SalesLT.Product;
-- ----------------------------------------------------------------------------------------------------------------
-- Desafío 1: 
-- Recuperar datos del nombre del cliente
SQL
SELECT Title, FirstName, MiddleName, LastName, Suffix
FROM SalesLT.Customer;
-- ----------------------------------------------------------------------------------------------------------------
-- Cree una lista de todos los nombres de contacto de los clientes que incluya el título, el nombre, el segundo nombre 
-- (si lo hay), el apellido y el sufijo (si lo hay) de todos los clientes.
-- Recuperar nombres y números de teléfono de clientes:
SQL
SELECT Salesperson, ISNULL(Title,'') + ' ' + LastName AS CustomerName, Phone
FROM SalesLT.Customer;
-- ----------------------------------------------------------------------------------------------------------------
-- Desafío 2: recuperar datos de pedidos de clientes
-- Se le ha pedido que proporcione una lista de todas las empresas clientes en el formato ID de cliente : Nombre de la empresa ; por ejemplo, 78: Bicicletas preferidas .
SQL
SELECT CAST(CustomerID AS varchar) + ': ' + CompanyName AS CustomerCompany
FROM SalesLT.Customer;
-- ----------------------------------------------------------------------------------------------------------------
-- La tabla SalesLT.SalesOrderHeader contiene registros de pedidos de ventas. Se le ha pedido que recupere datos para un informe que muestra:
-- El número de orden de venta y el número de revisión en el formato() – por ejemplo SO71774 (2).
-- La fecha del pedido convertida al formato estándar ANSI 102 ( aaaa.mm.dd , por ejemplo , 2015.01.31 ).
SQL
SELECT SalesOrderNumber + ' (' + STR(RevisionNumber, 1) + ')' AS OrderRevision,
   CONVERT(nvarchar(30), OrderDate, 102) AS OrderDate
FROM SalesLT.SalesOrderHeader;
-- ----------------------------------------------------------------------------------------------------------------
-- Desafío 3: recuperar los datos de contacto del cliente
-- Recupere los nombres de contacto de los clientes con el segundo nombre, si los conoce:
SQL
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS CustomerName
FROM SalesLT.Customer;
-- ----------------------------------------------------------------------------------------------------------------
Recuperar datos de contacto principal:
SQL
SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer;
-- ----------------------------------------------------------------------------------------------------------------
SQL
SELECT SalesOrderID, OrderDate,
    CASE
        WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
        ELSE 'Shipped'
    END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;
-- ----------------------------------------------------------------------------------------------------------------
SQL
UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;
-- ----------------------------------------------------------------------------------------------------------------
SQL
UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;