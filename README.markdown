fluent-plugin-select-if rename to fluent-plugin-select

# fluent-plugin-select

fluent-plugin-select(out\_select) is the non-buffered output plugin that can filter event logs by using ruby script.

## Example

This sample config outputs access logs that have status code 200.

    <source>
      type tail
      format apache
      path /var/log/httpd-access.log
      tag tag
    </source>
    <match tag>
      type select
      select record["code"] == "200"
      add_prefix filtered
      timeout 1s
    </match>
    <match filtered.tag>
      type file
      path output.log
    </match>


The parameter "select" can use 3 variables in event log; tag, time, record. The format of time is an integer number of seconds since the Epoch. The format of record is hash.


tag is alternative for add\_prefix. The 2 following match directives are same:

    <match tag>
      type select
      select record["code"] == "200"
      add_prefix filtered
      timeout 1s
    </match>
    <match tag>
      type select
      select record["code"] == "200"
      tag filtered.tag
      timeout 1s
    </match>

