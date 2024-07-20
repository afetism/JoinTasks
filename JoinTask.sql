--8. Display all visitors to the library (and students and teachers) and the books they took.
--8. Kitabxanan?n b�t�n ziyar?t�il?rini v? onlar?n g�t�rd�y� kitablar? �?xar?n.

--9. Print the most popular author (s) among students and the number of books of this author taken in the library.
--9. Studentl?r aras?nda ?n m??hur author(lar) v? onun(lar?n) g�t�r�lm�? kitablar?n?n say?n? �?xar?n.

--10. Print the most popular author (s) among the teachers and the number of books of this author taken in the library.
--10.T?l?b?l?r aras?nda ?n m??hur author(lar) v? onun(lar?n) g�t�r�lm�? kitablar?n?n say?n? �?xar?n.

--11. To deduce the most popular subjects (and) among students and teachers.
--11. Student v? Teacherl?r aras?nda ?n m??hur m�vzunu(lar?) �?xar?n.

--12. Display the number of teachers and students who visited the library.
--12. Kitabxanaya ne�? t?l?b? v? ne�? m�?llim g?ldiyini ekrana �?xar?n.

--13. If you count the total number of books in the library for 100%, then you need to calculate how many books (in percentage terms) each faculty took.
--13. ?g?r b�t�n kitablar?n say?n? 100% q?bul ets?k, siz h?r fakult?nin ne�? faiz kitab g�t�rd�y�n� hesablamal?s?n?z.


--14. Display the most reading faculty and the most reading chair.
--14, ?n �ox oxuyan fakult? c? dekanatl??? ekrana �?xar?n

--15. Show the author (s) of the most popular books among teachers and students.
--15. T?l?b?l?r v? m�?lliml?r aras?nda ?n m??hur authoru �?xar?n.

--16. Display the names of the most popular books among teachers and students.
--M�?llim v? T?l?b?l?r aras?nda ?n m??hur kitablar?n adlar?n? �?xar?n.

SELECT Top 1 Books.Name,TotalBook.Id_Book
FROM(SELECT Id_Book, SUM(BookCount) AS TotalCount
FROM (
    SELECT Id_Book, COUNT(Id_Book) AS BookCount
    FROM S_Cards
    GROUP BY Id_Book
    UNION ALL
    SELECT Id_Book, COUNT(Id_Book) AS BookCount
    FROM T_Cards
    GROUP BY Id_Book
) AS CombinedCounts
GROUP BY Id_Book
) AS TotalBook JOIN Books ON TotalBook.Id_Book=Books.Id
ORDER BY TotalBook.TotalCount DESC

--17. Show all students and teachers of designers.
--17. Dizayn sah?sind? olan b�t�n t?l?b? v? m�?lliml?ri ekrana �?xar?n.


--SOLUTION:
SELECT Teachers.FirstName+' '+Teachers.LastName
FROM  Teachers  JOIN Departments ON Teachers.Id_Dep=Departments.Id   
where Departments.Id=2
Union 
SELECT Students.FirstName+' '+Students.LastName
FROM Students JOIN Groups ON Students.Id_Group=Groups.Id
              JOIN Faculties ON Groups.Id_Faculty=Faculties.Id
WHERE Faculties.Id=2

--18. Show all information about students and teachers who have taken books.
--18. Kitab g�t�r?n t?l?b? v? m�?lliml?r haqq?nda informasiya �?xar?n.
SELECT Teachers.FirstName+' '+Teachers.LastName
FROM  Teachers  JOIN T_Cards ON Teachers.Id=T_Cards.Id_Teacher         
Union 
SELECT Students.FirstName+' '+Students.LastName
FROM Students JOIN S_Cards ON Students.Id=S_Cards.Id_Book
            
--19. Show books that were taken by both teachers and students.
--19. M�?llim v? ?agirdl?rin c?mi ne�? kitab g�t�rd�y�n� ekrana �?xar?n.
SELECT Books.Name
FROM  Teachers  JOIN T_Cards ON Teachers.Id=T_Cards.Id_Teacher
                JOIN Books ON Books.Id=T_Cards.Id_Book
Union 
SELECT Books.Name
FROM Students JOIN S_Cards ON Students.Id=S_Cards.Id_Book
              JOIN Books ON Books.Id=S_Cards.Id_Book
              
              
--20. Show how many books each librarian issued.
--20. H?r kitbxana�?n?n (libs) ne�? kitab verdiyini ekrana �?xar?n

SELECT Libs.Id,COUNT(DISTINCT T_Cards.Id)+count(Distinct S_Cards.Id)
FROM Libs JOIN S_Cards ON Libs.Id=S_Cards.Id_Lib
          JOIN T_Cards ON Libs.Id=T_Cards.Id_Lib
GROUP by Libs.Id




