# fluent-plugin-select-if

fluent-plugin-select-if(out\_select\_if) is the non-buffered output plugin that can filter event logs by using ruby script.

## Example

This sample config outputs access logs that have status code 200.

    <source>
      type tail
      format apache
      path /var/log/httpd-access.log
      tag tag
    </source>
    <match tag>
      type select_if
      select_if record["code"] == "200"
      add_prefix filtered
    </match>
    <match filtered.tag>
      type file
      path output.log
    </match>


The parameter "select\_if" can use 3 variables in event log; tag, time, record. The format of time is an integer number of seconds since the Epoch. The format of record is hash.
