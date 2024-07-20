--8. Display all visitors to the library (and students and teachers) and the books they took.
--8. Kitabxanan?n b�t�n ziyar?t�il?rini v? ONlar?n g�t�rd�y� kitablar? �?xar?n.
SELECT FirstName+' '+LAStName AS 'FullName of Visitors',Books.Name
FROM S_Cards JOIN Students ON Students.Id=S_Cards.Id_Student
             JOIN Books ON Books.Id=S_Cards.Id_Book
UNION ALL
SELECT FirstName+' '+LAStName AS 'FullName of Visitors',Books.Name
FROM T_Cards JOIN Teachers ON Teachers.Id=T_Cards.Id_Teacher
             JOIN Books ON Books.Id=T_Cards.Id_Book


--9. Print the most popular author (s) amONg students and the number of books of this author taken in the library.
--9. Studentl?r arAS?nda ?n m??hur author(lar) v? ONun(lar?n) g�t�r�lm�? kitablar?n?n say?n? �?xar?n.
WITH TotalCountOfAuthor_T AS
(
SELECT Authors.Id,COUNT(Authors.Id) AS  CountOfAuthor
FROM T_Cards JOIN Books ON T_Cards.Id_Book=Books.Id
             JOIN Authors ON Books.Id_Author=Authors.Id
GROUP BY Authors.Id
),
MaxCountofAuthor AS
(
SELECT MAX(CountOfAuthor)  AS MaxAuthor
FROM TotalCountOfAuthor_T
)

SELECT Authors.Id 'Id Of Author' ,Authors.FirstName+' '+Authors.LAStName 'FullName of Author'
FROM TotalCountOfAuthor_T JOIN Authors ON TotalCountOfAuthor_T.Id=Authors.Id
                          JOIN MaxCountofAuthor ON MaxCountofAuthor.MaxAuthor=TotalCountOfAuthor_T.CountOfAuthor

--10. Print the most popular author (s) amONg the teachers and the number of books of this author taken in the library.
--10.T?l?b?l?r arAS?nda ?n m??hur author(lar) v? ONun(lar?n) g�t�r�lm�? kitablar?n?n say?n? �?xar?n.
WITH TotalCountOfAuthor AS
(
SELECT Authors.Id,COUNT(Authors.Id) AS  CountOfAuthor
FROM S_Cards JOIN Books ON S_Cards.Id_Book=Books.Id
             JOIN Authors ON Books.Id_Author=Authors.Id
GROUP BY Authors.Id
),
MaxCountofAuthor AS
(
SELECT MAX(CountOfAuthor)  AS MaxAuthor
FROM TotalCountOfAuthor
)

SELECT Authors.Id 'Id Of Author' ,Authors.FirstName+' '+Authors.LAStName 'FullName of Author'
FROM TotalCountOfAuthor JOIN Authors ON TotalCountOfAuthor.Id=Authors.Id
                        JOIN MaxCountofAuthor ON MaxCountofAuthor.MaxAuthor=TotalCountOfAuthor.CountOfAuthor


--11. To deduce the most popular subjects (and) amONg students and teachers.
--11. Student v? Teacherl?r arAS?nda ?n m??hur m�vzunu(lar?) �?xar?n.
WITH TotalCountofThems AS (
SELECT Id_Themes, SUM(Count) AS TotalCount
FROM (
    SELECT Id_Themes, COUNT(Id_Themes) AS Count
    FROM S_Cards 
    JOIN Books ON S_Cards.Id_Book = Books.Id
    JOIN Themes ON Books.Id_Themes = Themes.Id
    GROUP BY Id_Themes
    UNION ALL
    SELECT Id_Themes, COUNT(Id_Themes) AS Count
    FROM T_Cards 
    JOIN Books ON T_Cards.Id_Book = Books.Id
    JOIN Themes ON Books.Id_Themes = Themes.Id
    GROUP BY Id_Themes
) AS CombinedCounts
GROUP BY Id_Themes
),
MaxCountOfThemes AS (
SELECT MAX(TotalCount) AS MaxCount
FROM TotalCountofThems
)

SELECT Themes.Id,Themes.Name
FROM TotalCountofThems JOIN MaxCountOfThemes ON TotalCountofThems.TotalCount=MaxCountOfThemes.MaxCount
                       JOIN Themes ON Themes.Id=TotalCountofThems.Id_Themes

--12. Display the number of teachers and students who visited the library.
--12. Kitabxanaya ne�? t?l?b? v? ne�? m�?llim g?ldiyini ekrana �?xar?n.

SELECT SUM(Visitor) AS TotalVisitor
FROM (
SELECT count(distinct Id_Student) AS Visitor
FROM S_Cards
UNION 
SELECT count(distinct Id_Teacher) AS Visitor
FROM T_Cards) AS Vis


--13. If you count the total number of books in the library for 100%, then you need to calculate how many books (in percentage terms) each faculty took.
--13. ?g?r b�t�n kitablar?n say?n? 100% q?bul ets?k, siz h?r fakult?nin ne�? faiz kitab g�t�rd�y�n� hesablamal?s?n?z.
WITH BookQuantityofEachFaculty AS(
SELECT Id_Faculty ,COUNT(Id_Book) AS QuantOfBook
FROM S_Cards JOIN Students ON S_Cards.Id_Student =Students.Id
             JOIN Groups ON Students.Id_Group=Groups.Id
			 JOIN Faculties ON Faculties.Id=Groups.Id_Faculty
GROUP BY Id_Faculty
),

TotalCountofBook AS (SELECT SUM(Quantity) AS TotalQuantity
                     FROM Books)

SELECT Id_Faculty,QuantOfBook*100/TotalQuantity AS "%"
FROM TotalCountofBook T ,BookQuantityofEachFaculty QF



--14. Display the most reading faculty and the most reading chair.
--14, ?n �ox oxuyan fakult? c? dekanatl??? ekrana �?xar?n
WITH St_Faculty AS(
SELECT Id_Faculty,COUNT (Id_Faculty) AS CountOfFacul
FROM Students JOIN Groups ON Students.Id_Group=Groups.Id
              JOIN Faculties ON Faculties.Id=Groups.Id_Faculty
GROUP BY Id_Faculty



),
MAXFACULTY AS(
SELECT MAX(CountOfFacul)AS MaxFacul
FROM St_Faculty
)


SELECT Faculties.Id,Faculties.Name
FROM St_Faculty JOIN MAXFACULTY ON St_Faculty.CountOfFacul=MAXFACULTY.MaxFacul
                JOIN Faculties ON Faculties.Id=St_Faculty.Id_Faculty



--15. Show the author (s) of the most popular books amONg teachers and students.
--15. T?l?b?l?r v? m�?lliml?r arAS?nda ?n m??hur authoru �?xar?n.
WITH TotalBook AS (
SELECT Id_Book, SUM(BookCount) AS TotalCount
FROM (SELECT Id_Book, COUNT(Id_Book) AS BookCount
        FROM S_Cards
        GROUP BY Id_Book
        UNION ALL
        SELECT Id_Book, COUNT(Id_Book) AS BookCount
        FROM T_Cards
        GROUP BY Id_Book
    ) AS CombinedCounts
    GROUP BY Id_Book
),
MaxCount AS (
SELECT MAX(TotalCount) AS MaxTotalCount
FROM TotalBook
)

 

SELECT Authors.Id,Authors.FirstName+' '+Authors.LAStName
FROM TotalBook
JOIN Books ON TotalBook.Id_Book = Books.Id
JOIN MaxCount ON TotalBook.TotalCount = MaxCount.MaxTotalCount
JOIN Authors ON Authors.Id=Books.Id_Author
--16. Display the names of the most popular books amONg teachers and students.
--M�?llim v? T?l?b?l?r arAS?nda ?n m??hur kitablar?n adlar?n? �?xar?n.


WITH TotalBook AS (
SELECT Id_Book, SUM(BookCount) AS TotalCount
FROM (SELECT Id_Book, COUNT(Id_Book) AS BookCount
        FROM S_Cards
        GROUP BY Id_Book
        UNION ALL
        SELECT Id_Book, COUNT(Id_Book) AS BookCount
        FROM T_Cards
        GROUP BY Id_Book
    ) AS CombinedCounts
    GROUP BY Id_Book
),
MaxCount AS (
SELECT MAX(TotalCount) AS MaxTotalCount
FROM TotalBook
)

SELECT Books.Name
FROM TotalBook
JOIN Books ON TotalBook.Id_Book = Books.Id
JOIN MaxCount ON TotalBook.TotalCount = MaxCount.MaxTotalCount;

--17. Show all students and teachers of designers.
--17. Dizayn sah?sind? olan b�t�n t?l?b? v? m�?lliml?ri ekrana �?xar?n.
SELECT Teachers.FirstName+' '+Teachers.LAStName
FROM  Teachers  JOIN Departments ON Teachers.Id_Dep=Departments.Id   
WHERE Departments.Id=2
UniON 
SELECT Students.FirstName+' '+Students.LAStName
FROM Students JOIN Groups ON Students.Id_Group=Groups.Id
              JOIN Faculties ON Groups.Id_Faculty=Faculties.Id
WHERE Faculties.Id=2

--18. Show all informatiON about students and teachers who have taken books.
--18. Kitab g�t�r?n t?l?b? v? m�?lliml?r haqq?nda informASiya �?xar?n.
SELECT Teachers.FirstName+' '+Teachers.LAStName
FROM  Teachers  JOIN T_Cards ON Teachers.Id=T_Cards.Id_Teacher         
UniON 
SELECT Students.FirstName+' '+Students.LAStName
FROM Students JOIN S_Cards ON Students.Id=S_Cards.Id_Book
            
--19. Show books that were taken by both teachers and students.
--19. M�?llim v? ?agirdl?rin c?mi ne�? kitab g�t�rd�y�n� ekrana �?xar?n.
SELECT Books.Name
FROM  Teachers  JOIN T_Cards ON Teachers.Id=T_Cards.Id_Teacher
                JOIN Books ON Books.Id=T_Cards.Id_Book
UniON 
SELECT Books.Name
FROM Students JOIN S_Cards ON Students.Id=S_Cards.Id_Book
              JOIN Books ON Books.Id=S_Cards.Id_Book
              
              
--20. Show how many books each librarian issued.
--20. H?r kitbxana�?n?n (libs) ne�? kitab verdiyini ekrana �?xar?n

SELECT Libs.Id,COUNT(DISTINCT T_Cards.Id)+count(Distinct S_Cards.Id)
FROM Libs JOIN S_Cards ON Libs.Id=S_Cards.Id_Lib
          JOIN T_Cards ON Libs.Id=T_Cards.Id_Lib
GROUP by Libs.Id




