package UDDI;

# Copyright 2000 ActiveState Tool Corp.

use strict;

our $VERSION = "0.01";

our $registry = "http://test.uddi.microsoft.com/inquire";
#our $registry = "http://uddi.microsoft.com/inquire";
our $TRACE;

sub find_business
{
    my %arg = @_;
    my $msg = qq(<find_business generic="1.0");
    if (my $max_rows = delete $arg{max_rows}) {
	$msg .= qq( maxRows="$max_rows");
    }
    $msg .= qq( xmlns="urn:uddi-org:api">);
    if (my $n = delete $arg{name}) {
	$msg .= qq(<name>$n</name>);
    }
    $msg .= qq(</find_business>);
    if (%arg) {
	my $a = join(", ", keys %arg);
	warn "Unrecongized parameters: $a";
    }

    return _request($msg);
}

sub get_bindingDetail
{
    my $msg = qq(<get_bindingDetail generic="1.0" xmlns="urn:uddi-org:api">);
    for (@_) {
	$msg .= "<bindingKey>$_</bindingKey>";
    }
    $msg .= "</get_bindingDetail>";

    return _request($msg);
}

sub _get_businessDetail
{
    my $ext = (shift) ? "Ext" : "";
    my $msg = qq(<get_businessDetail$ext generic="1.0" xmlns="urn:uddi-org:api">);
    for (@_) {
	$msg .= "<businessKey>$_</businessKey>";
    }
    $msg .= "</get_businessDetail$ext>";

    return _request($msg);
}

sub get_businessDetail
{
    unshift(@_, 0);
    goto &_get_businessDetail;
}

sub get_businessDetailExt
{
    unshift(@_, 1);
    goto &_get_businessDetail;
}

sub get_serviceDetail
{
    my $msg = qq(<get_serviceDetail generic="1.0" xmlns="urn:uddi-org:api">);
    for (@_) {
	$msg .= "<serviceKey>$_</serviceKey>";
    }
    $msg .= "</get_serviceDetail>";

    return _request($msg);
}

sub get_tModelDetail
{
    my $msg = qq(<get_tModelDetail generic="1.0" xmlns="urn:uddi-org:api">);
    for (@_) {
	$msg .= "<tModelKey>$_</tModelKey>";
    }
    $msg .= "</get_tModelDetail>";

    return _request($msg);
}



# ----------------------------------

my $ua;

sub _request {
    my $msg = shift;

    require LWP::UserAgent;
    $ua ||= LWP::UserAgent->new;

    my $req = HTTP::Request->new(POST => $registry);
    $req->date(time);
    $req->header("SOAPAction", '""');
    $req->content_type("text/xml");
    $req->content(<<"EOT");
<?xml version="1.0" encoding="UTF-8"?>
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body>$msg</Body></Envelope>
EOT

    print $TRACE "\n\n", ("=" x 50), "\n", $req->as_string if $TRACE;

    my $res = $ua->request($req);

    print $TRACE $res->as_string if $TRACE;

    if ($res->content_type eq "text/xml" && $res->header("SOAPAction")) {
	#warn $res->content;

	require UDDI::SOAP;
	my $envelope = UDDI::SOAP::parse($res->content);
	die "MustUnderstand" if $envelope->must_understand_headers;

	my $obj = $envelope->body_content;

	die $obj if ref($obj) eq "UDDI::SOAP::Fault";

	return $obj;

    }

    die $res;
}

# The following table is auto-generated from:
# "UDDI API schema.  Version 1.0, revision 0.  Last change 2000-09-06"

# urn:uddi-org:api elements

sub TEXT_CONTENT () { 0x01 }
sub ELEM_CONTENT () { 0x02 }

our %elementContent = (
    'UDDI::addressLine'           => 0x01,
    'UDDI::bindingKey'            => 0x01,
    'UDDI::businessKey'           => 0x01,
    'UDDI::description'           => 0x01,
    'UDDI::keyValue'              => 0x01,
    'UDDI::name'                  => 0x01,
    'UDDI::overviewURL'           => 0x01,
    'UDDI::personName'            => 0x01,
    'UDDI::serviceKey'            => 0x01,
    'UDDI::tModelKey'             => 0x01,
    'UDDI::uploadRegister'        => 0x01,
    'UDDI::address'               => 0x02,
    'UDDI::contacts'              => 0x02,
    'UDDI::contact'               => 0x02,
    'UDDI::discoveryURL'          => 0x01,
    'UDDI::discoveryURLs'         => 0x02,
    'UDDI::phone'                 => 0x01,
    'UDDI::email'                 => 0x01,
    'UDDI::businessEntity'        => 0x02,
    'UDDI::businessServices'      => 0x02,
    'UDDI::businessService'       => 0x02,
    'UDDI::bindingTemplates'      => 0x02,
    'UDDI::identifierBag'         => 0x02,
    'UDDI::keyedReference'        => 0000,
    'UDDI::categoryBag'           => 0x02,
    'UDDI::bindingTemplate'       => 0x02,
    'UDDI::accessPoint'           => 0x01,
    'UDDI::hostingRedirector'     => 0000,
    'UDDI::tModelInstanceDetails' => 0x02,
    'UDDI::tModelInstanceInfo'    => 0x02,
    'UDDI::instanceDetails'       => 0x02,
    'UDDI::instanceParms'         => 0x01,
    'UDDI::tModel'                => 0x02,
    'UDDI::tModelBag'             => 0x02,
    'UDDI::overviewDoc'           => 0x02,
    'UDDI::authInfo'              => 0x01,
    'UDDI::get_authToken'         => 0000,
    'UDDI::authToken'             => 0x02,
    'UDDI::discard_authToken'     => 0x02,
    'UDDI::save_tModel'           => 0x02,
    'UDDI::delete_tModel'         => 0x02,
    'UDDI::save_business'         => 0x02,
    'UDDI::delete_business'       => 0x02,
    'UDDI::save_service'          => 0x02,
    'UDDI::delete_service'        => 0x02,
    'UDDI::save_binding'          => 0x02,
    'UDDI::delete_binding'        => 0x02,
    'UDDI::dispositionReport'     => 0x02,
    'UDDI::result'                => 0x02,
    'UDDI::errInfo'               => 0x01,
    'UDDI::findQualifiers'        => 0x02,
    'UDDI::findQualifier'         => 0x01,
    'UDDI::find_tModel'           => 0x02,
    'UDDI::find_business'         => 0x02,
    'UDDI::find_binding'          => 0x02,
    'UDDI::find_service'          => 0x02,
    'UDDI::serviceList'           => 0x02,
    'UDDI::businessList'          => 0x02,
    'UDDI::tModelList'            => 0x02,
    'UDDI::businessInfo'          => 0x02,
    'UDDI::businessInfos'         => 0x02,
    'UDDI::serviceInfo'           => 0x02,
    'UDDI::serviceInfos'          => 0x02,
    'UDDI::get_businessDetail'    => 0x02,
    'UDDI::businessDetail'        => 0x02,
    'UDDI::get_serviceDetail'     => 0x02,
    'UDDI::serviceDetail'         => 0x02,
    'UDDI::get_registeredInfo'    => 0x02,
    'UDDI::registeredInfo'        => 0x02,
    'UDDI::tModelInfo'            => 0x02,
    'UDDI::tModelInfos'           => 0x02,
    'UDDI::get_tModelDetail'      => 0x02,
    'UDDI::tModelDetail'          => 0x02,
    'UDDI::businessEntityExt'     => 0x02,
    'UDDI::get_businessDetailExt' => 0x02,
    'UDDI::businessDetailExt'     => 0x02,
    'UDDI::get_bindingDetail'     => 0x02,
    'UDDI::bindingDetail'         => 0x02,
    'UDDI::validate_categorization' => 0x02,
);


package UDDI::Object;

use overload '""' => \&as_string;

our $AUTOLOAD;

sub AUTOLOAD
{
    my $self = shift;
    my $method = substr($AUTOLOAD, rindex($AUTOLOAD, '::')+2);
    return if $method eq "DESTROY";

    my $k = "urn:uddi-org:api\0$method";
    if (exists $self->[0]{$k}) {
	return $self->[0]{$k};
    }

    my @res = grep ref($_) eq "UDDI::$method", @$self;
    return wantarray ? @res : $res[0];
}

sub xml_lang
{
    my $self = shift;
    return $self->[0]{"xml\0lang"};
}

sub as_string
{
    my($self, $elem) = @_;
    my $class = ref($self);

    unless ($class) {
	# plain string
	if ($elem) {
	    # quote
	    for ($self) {
		s/&/&amp;/g;
		s/</&lt;/g;
	    }
	}
	return $self;
    }

    return $self->[1]
	if $UDDI::elementContent{$class} == UDDI::TEXT_CONTENT && !$elem;

    (my $tag = $class) =~ s/^UDDI:://;


    my @e = @$self;
    my $attr = shift @e;
    if (%$attr) {
	my @attr;
	for my $k (sort keys %$attr) {
	    my $v = $attr->{$k};
	    $k =~ s/^[^\0]*\0//; # kill namespace qualifier
	    for ($v) {
		s/&/&amp;/g;
	        s/\"/&quot;/g;
		s/</&lt;/g;
	    }
	    @attr = qq($k="$v");
	}
	$attr = join(" ", "", @attr);
    }
    else {
	$attr = "";
    }

    return "<$tag$attr/>" unless @e;

    return join("", "<$tag$attr>", (map as_string($_, 1), @e), "</$tag>");
}

1;
