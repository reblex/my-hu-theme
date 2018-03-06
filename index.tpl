<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ .Name }}</title>
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,600,300,700,800' rel='stylesheet' type='text/css'>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.2.0/styles/darkula.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.2.0/highlight.min.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
    <style>{{ template "custom.css" }}</style>

</head>
<body data-spy="scroll" data-target=".scrollspy">
<div id="sidebar-wrapper" class="hidden-xs">
    {{ template "menu.tpl" . }}
</div>
<div id="page-content-wrapper" class="splitted">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <div class="row ">
                    <div class="col-md-7">
                        <h1 id="doc-general-notes">
                            {{ .Name }}
                            <a href="#doc-general-notes"><i class="glyphicon glyphicon-link"></i></a>
                        </h1>
                    </div>
                    <div class="col-md-5">
                        <!-- <div class="dropdown">
                          <button class="btn btn-default" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                            Code language
                            <span class="caret"></span>
                          </button>
                          <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                            <li><a href="#" onClick="$('.request-example-curl').each(function(){$(this).addClass('active')});$('.request-example-http').each(function(){$(this).removeClass('active')});">cURL</a></li>
                            <li><a href="#" onClick="$('.request-example-curl').each(function(){$(this).removeClass('active')});$('.request-example-http').each(function(){$(this).addClass('active')});">HTTP</a></li>
                          </ul>
                        </div> -->
                    </div>
                </div>

                <div class="col-md-7 doc no-padding">
                {{ markdown .Description }}
                </div>

                {{ with $structures := .Structures }}
                <h2 id="doc-api-structures">
                    API structures
                    <a href="#doc-api-structures"><i class="glyphicon glyphicon-link"></i></a>
                </h2>

                {{ range $structures }}

                    <h3 id="struct-{{ .Name }}">
                        {{ .Name }}
                        <a href="#struct-{{ .Name }}"><i class="glyphicon glyphicon-link"></i></a>
                    </h3>

                    <p>{{ .Description }}</p>

                    <table class="table table-bordered">
                    {{ range .Fields }}
                        <tr>
                            <th>{{ .Name }}</th>
                            <td>{{ .Type }}</td>
                            <td>{{ .Description }}</td>
                        </tr>
                    {{ end }}
                    </table>

                {{ end }}

                {{ end }}

                <a href="#doc-api-detail"><hr class="clear" id="doc-api-detail"></a>

                {{ range .Folders }}
                <div class="endpoints-group ">
                    <h3 id="folder-{{ slugify .Name }}">
                        {{ .Name }}
                        <a href="#folder-{{ slugify .Name }}"><i class="glyphicon glyphicon-link"></i></a>
                    </h3>
                    <hr class="clear">

                    <div class="col-md-7 doc no-padding">{{ markdown .Description }}</div>

                    {{ range .Order }}

                        {{ with $req := findRequest $.Requests . }}
                        <div class="request">
                            <div class="col-md-7">
                            <h4 id="request-{{ slugify $req.Name }}">
                                <span class="strong {{ $req.Method }}">{{ $req.Method }}</span> {{ $req.Name }}
                                <a href="#request-{{ slugify $req.Name }}"><i class="glyphicon glyphicon-link"></i></a>
                            </h4>
                            <input class="bg-warning form-control" disabled value="{{ $req.URL}}" style="width:95%">
                            <span class="markdown">
                                {{ markdown $req.Description }}
                            </span>
                            <hr class="clear">

                            {{ with $req.Responses }}
                            <div>
                                <ul class="nav nav-tabs" role="tablist">
                                    {{ range $index, $res := . }}
                                    <li role="presentation"{{ if eq $index 0 }} class="active"{{ end }}>
                                        <a href="#request-{{ slugify $req.Name }}-responses-{{ $res.ID }}" data-toggle="tab">
                                            {{ if eq (len $req.Responses) 1 }}
                                                Response
                                            {{ else}}
                                                {{ $res.Name }}
                                            {{ end }}
                                        </a>
                                    </li>
                                    {{ end }}
                                </ul>
                                <div class="tab-content">
                                    {{ range $index, $res := . }}
                                    <div class="tab-pane{{ if eq $index 0 }} active{{ end }}" id="request-{{ slugify $req.Name }}-responses-{{ $res.ID }}">
                                        <table class="table table-bordered">
                                            <tr><th style="width: 20%;">Status</th><td>{{ $res.ResponseCode.Code }} {{ $res.ResponseCode.Name }}</td></tr>
                                            {{ range $res.Headers }}
                                            <tr><th style="width: 20%;">{{ .Name }}</th><td>{{ .Value }}</td></tr>
                                            {{ end }}
                                            {{ if hasContent $res.Text }}
                                                {{ with $example := indentJSON $res.Text }}
                                                <tr><td class="doc response-text-sample" colspan="2">
                                                    <pre><code>{{ $example }}</code></pre>
                                                </td></tr>
                                                {{ end }}
                                            {{ end }}
                                        </table>
                                    </div>
                                    {{ end }}
                                </div>
                            </div>
                            {{ end }}
                                {{ if  $req.Headers }}
                                <h6 class="text-uppercase ">Headers</h6>
                                <div class="param row">
                                    {{ range $req.Headers }}
                                    <div class="name col-md-3"><strong>{{ .Name }}</strong></div>
                                    <div class="value col-md-9">{{ .Value }}</div>
                                    {{ end }}
                                </div>
                                {{ end }}

                                {{ if $req.Data }}
                                <h6 class="text-uppercase ">Body</h6>
                                <div class="param row">
                                    {{ $req.Data }}
                                </div>
                                {{ end }}


                            </div>

                            <div class="col-md-5">
                                <div class="code">
                                    <small class="PATCH">Sample request</small>
                                    <div class="panel panel-dark">
                                        <div class="panel-heading">
                                            <small>{{ .Name }}</small>
                                            <a href="#/"  class="method-toggle curl-toggle" onClick="$('.request-example-curl.{{ slugify .Name }}').show();$('.request-example-http.{{ slugify .Name }}').hide();">cURL</a>
                                            <a href="#/" class="method-toggle http-toggle" onClick="$('.request-example-curl.{{ slugify .Name }}').hide();$('.request-example-http.{{ slugify .Name }}').show();">HTTP</a>
                                        </div>
                                        <div class="panel-body">
                                            <div class="tab-content">
                                                <div class="tab-pane active request-example-curl {{ slugify .Name }}">
                                                    <pre><code class="hljs curl">{{ curlSnippet $req }}</code></pre>
                                                </div>
                                                <div class="tab-pane request-example-http {{ slugify .Name }}">
                                                    <pre><code class="hljs http">{{ httpSnippet $req }}</code></pre>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <hr class="clear">
                        {{ end }}

                    {{ end }}

                </div>
                {{ end }}
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-2.2.2.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

</body>
</html>
