
/* 
 *Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”
1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
3.В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

4.(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
5.(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

Практическое задание теме “Агрегация данных”
6.Подсчитайте средний возраст пользователей в таблице users
7.Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.
8.(по желанию) Подсчитайте произведение чисел в столбце таблицы
 
 * */ 


-- 1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

ALTER TABLE users
	ADD COLUMN created_at DATETIME, 
	ADD COLUMN updated_at DATETIME;


UPDATE `users`
	SET 
		created_at = NOW(),
		updated_at = NOW();

/* 2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и
 в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу 
 DATETIME, сохранив введеные ранее значения.*/

SELECT STR_TO_DATE('20.10.2002 6:15','%d.%m.%Y %H:%i');

DROP TABLE IF EXISTS users2;
CREATE TABLE users2 (
		created_at VARCHAR(255), 
		updated_at VARCHAR(255));
	
INSERT INTO users2 VALUES 
	('20.10.2017 8:10', '20.10.2002 6:15');


UPDATE users2
	SET 
		created_at = STR_TO_DATE(created_at,'%d.%m.%Y %H:%i'),
		updated_at = STR_TO_DATE(updated_at,'%d.%m.%Y %H:%i');

ALTER TABLE users2
	MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	MODIFY COLUMN updated_at DATETIME DEFAULT NOW();



/* 3.В таблице складских запасов storehouses_products в поле value могут встречаться самые 
 *  разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
 Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 Однако, нулевые запасы должны выводиться в конце, после всех записей.*/

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id SERIAL,
	value INT);
INSERT INTO storehouses_products VALUES
	('1', '0'),
	('2', '1'),
	('3', '2'),
	('4', '3'),
	('5', '0');

SELECT id, value FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;


/*
 * 4.(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
 * Месяцы заданы в виде списка английских названий ('may', 'august')
 * Using profiles table
 */

SELECT * FROM profiles WHERE DATE_FORMAT(birthday, '%M') = "may" OR DATE_FORMAT(birthday, '%M') = "august";

/*5.(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
 * SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
 *
*/
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
	id SERIAL,
	name VARCHAR(55));

INSERT INTO catalogs VALUES 
	('1', "First position"),
	('2', "Second position"),
	('3', "Third position"),
	('4', "Fourth position"),
	('5', "Fifth position"),
	('6', "Sixth position");

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);

-- 6.Подсчитайте средний возраст пользователей в таблице users
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday, NOW())) AS age FROM profiles;

/*
 * 7.Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 */

SELECT COUNT(*), DATE_FORMAT(CONCAT(YEAR(CURRENT_DATE), '-', RIGHT(birthday,5)), '%a') AS dob FROM profiles GROUP BY dob;

/*
 * 8.(по желанию) Подсчитайте произведение чисел в столбце таблицы
 */

DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (
	id SERIAL,
	value int);

INSERT INTO numbers VALUES 
	('1', '1'),
	('2', '3'),
	('3', '1'),
	('4', '2'),
	('5', '7'),
	('6', '5'),
	('7', '7'),
	('8', '5');

SELECT ROUND(EXP(SUM(LN(value)))) FROM numbers;
