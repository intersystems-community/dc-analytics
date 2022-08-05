Class History.AvgComments Extends %Persistent [ DependsOn = Community.Comment ]
{

Parameter DSTIME = "AUTO";

Property Added As %Date;

Index Added On Added [ Unique ];

Property PerDay As %Float;

Storage Default
{
<Data name="AvgCommentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Added</Value>
</Value>
<Value name="3">
<Value>PerDay</Value>
</Value>
</Data>
<DataLocation>^History.AvgCommentsD</DataLocation>
<DefaultData>AvgCommentsDefaultData</DefaultData>
<IdLocation>^History.AvgCommentsD</IdLocation>
<IndexLocation>^History.AvgCommentsI</IndexLocation>
<StreamLocation>^History.AvgCommentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

