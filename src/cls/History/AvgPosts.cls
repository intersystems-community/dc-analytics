Class History.AvgPosts Extends %Persistent [ DependsOn = Community.Post ]
{

Parameter DSTIME = "AUTO";

Property Added As %Date;

Index Added On Added [ Unique ];

Property PerDay As %Float;

Storage Default
{
<Data name="AvgPostsDefaultData">
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
<DataLocation>^History.AvgPostsD</DataLocation>
<DefaultData>AvgPostsDefaultData</DefaultData>
<IdLocation>^History.AvgPostsD</IdLocation>
<IndexLocation>^History.AvgPostsI</IndexLocation>
<StreamLocation>^History.AvgPostsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

