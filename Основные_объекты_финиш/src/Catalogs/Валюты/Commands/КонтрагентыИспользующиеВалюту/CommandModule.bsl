
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ВКакомПолеИщемИЧто = Новый Структура("ВалютаРасчетов", ПараметрКоманды );
	ПараметрыФормы = Новый Структура("Отбор",ВКакомПолеИщемИЧто );
	ОткрытьФорму("Справочник.Контрагенты.ФормаСписка"
	, ПараметрыФормы
	, ПараметрыВыполненияКоманды.Источник
	, ПараметрыВыполненияКоманды.Уникальность
	, ПараметрыВыполненияКоманды.Окно
	, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры