Class History.ActiveMembers Extends %Persistent [ DependsOn = Community.Member ]
{

Parameter DSTIME = "AUTO";

Property Member As Community.Member;

Index Member On Member [ Unique ];

Property Link As %String(MAXLEN = 250);

Property Added As %Date;

Storage Default
{
<Data name="ActiveMembersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>All</Value>
</Value>
<Value name="3">
<Value>Active</Value>
</Value>
<Value name="4">
<Value>Added</Value>
</Value>
<Value name="5">
<Value>AllMembers</Value>
</Value>
<Value name="6">
<Value>ActiveMembers</Value>
</Value>
<Value name="7">
<Value>Member</Value>
</Value>
<Value name="8">
<Value>Link</Value>
</Value>
</Data>
<DataLocation>^History.ActiveMembersD</DataLocation>
<DefaultData>ActiveMembersDefaultData</DefaultData>
<IdLocation>^History.ActiveMembersD</IdLocation>
<IndexLocation>^History.ActiveMembersI</IndexLocation>
<StreamLocation>^History.ActiveMembersS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

