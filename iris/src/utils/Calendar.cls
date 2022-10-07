Class utils.Calendar Extends %Persistent
{

Index FullDateIdx On FullDate [ Type = bitmap ];

Property FullDate As %Library.Date;

Property MonthYear As %Library.String(MAXLEN = 8);

Property MonthYearNum As %Library.Integer;

Property Year As %Library.Integer;

Storage Default
{
<Data name="CalendarDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FullDate</Value>
</Value>
<Value name="3">
<Value>MonthYear</Value>
</Value>
<Value name="4">
<Value>MonthYearNum</Value>
</Value>
<Value name="5">
<Value>Year</Value>
</Value>
</Data>
<DataLocation>^utils.CalendarD</DataLocation>
<DefaultData>CalendarDefaultData</DefaultData>
<IdLocation>^utils.CalendarD</IdLocation>
<IndexLocation>^utils.CalendarI</IndexLocation>
<StreamLocation>^utils.CalendarS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
