WITH t1 AS
  (SELECT COUNT(*) AS Purchases,
          c.Country,
          g.Name,
          g.GenreId
   FROM Customer c
   JOIN Invoice i ON c.CustomerId = i.CustomerId
   JOIN InvoiceLine l ON i.InvoiceId = l.InvoiceId
   JOIN Track t ON l.TrackId = t.TrackId
   JOIN Genre g ON g.GenreId = t.GenreId
   GROUP BY 3,
            2),
     t2 AS
  (SELECT max(Purchases) AS Purchases,
          Country
   FROM t1
   GROUP BY 2)
SELECT t1.*
FROM t1
JOIN t2 ON t1.Country = t2.Country
AND t1.Purchases = t2.Purchases
ORDER BY t1.Country;


SELECT ar.Name,
       Count(*)
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine l ON t.TrackId = l.TrackId
JOIN Invoice i ON l.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


SELECT strftime('%Y', i.InvoiceDate) YEAR,
                                     e.EmployeeId,
                                     e.FirstName,
                                     e.LastName,
                                     sum(i.Total) TotalSale
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON e.EmployeeId = c.SupportRepId
GROUP BY 1,
         2
ORDER BY 1;

WITH t1 AS
  (SELECT BillingCountry,
          sum(Total) AS Total
   FROM Invoice
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 5),
     t2 AS
  (SELECT strftime('%Y', i.InvoiceDate) YEAR,
                                        BillingCountry AS Country,
                                        sum(Total) Total
   FROM Invoice i
   GROUP BY 1,
            2)
SELECT t2.*
FROM t1
JOIN t2 ON t1.BillingCountry = t2.Country;