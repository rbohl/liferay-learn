# Backing Up Elasticsearch

[Elasticsearch replicas](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/index-modules.html#index-modules-settings) protect against a node going down, but they won't help you with a catastrophic failure. Only good backup practices can help you then.

Back up your Elasticsearch cluster and test restoring the backup in three steps: 

1. Create a repository

1. Take a snapshot of the Elasticsearch cluster

1. Restore from the snapshot

```note::
   For more detailed information, refer to Elastic's `Elasticsearch administration guide <https://www.elastic.co/guide/en/elasticsearch/guide/master/administration.html>`_, and in particular to the `Snapshot and Restore module <https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshot-restore.html>`_.
```

## Create a Repository

First [create a repository](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshots-register-repository.html) to store your snapshots. Here are the supported repository types:

* Shared file system, such as a Network File System or NAS
* Amazon S3
* HDFS (Hadoop Distributed File System)
* Azure Cloud

If you want to store snapshots on a shared file system, first register the path to the shared file system in each node's `elasticsearch.yml` using the [`path.repo` setting](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshots-register-repository.html#snapshots-filesystem-repository). For example,

```yaml
path.repo: ["path/to/shared/file/system/"]
```

After registering the path to the folder hosting the repository (make sure the folder exists), create the repository with a `PUT` command. For example,

```bash
curl -X PUT "localhost:9200/_snapshot/test_backup" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/path/to/shared/file/system/"
  }
}'
```

Replace `localhost:9200` with your system's `hostname:port`, replace `test_backup` with the name of the repository to create, and replace the `location` setting value with the absolute path to your shared file system.

If you created the repository correctly, the command returns this result:

```json
{"acknowledged":true}
```

Now that the repository exists, create a snapshot.

## Take a Snapshot of the Cluster

The easiest snapshot approach is to create a [snapshot of all the indexes in your cluster](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshots-take-snapshot.html). For example,

```bash
curl -XPUT localhost:9200/_snapshot/test_backup/snapshot_1
```

A successful snapshot command returns this result:

```json
{"accepted":true}
```

You can limit snapshots to specific indexes too. For example, you may have Liferay Enterprise Search Monitoring but want to exclude monitoring indexes from the snapshot. Explicitly declare the indexes to include in the snapshot. For example,

```bash
curl -XPUT localhost:9200/_snapshot/test_backup/snapshot_2
{ "indices": "liferay-0,liferay-20116" }
```

To list all indexes and index metrics, execute this command:

```bash
curl -X GET "localhost:9200/_cat/indices?v"
```

Example index metrics,

```bash
health status index         uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   liferay-20099 obqiNE1_SDqfuz7rincrGQ   1   0        195            0    303.1kb        303.1kb
green  open   liferay-47206 3YEjtye1S9OVT0i0EZcXcw   1   0          7            0     69.7kb         69.7kb
green  open   liferay-0     shBWwpkXRxuAmGEaE475ug   1   0        147            1    390.9kb        390.9kb
```

```note::
   Elasticsearch uses a *smart snapshots* approach. To understand what that means, consider a single index. The first snapshot includes a copy of the entire index, while subsequent snapshots only include the delta between the first, complete index snapshot and the current state of the index.
```

Eventually you'll end up with a lot of snapshots in your repository, and no matter how cleverly you name the snapshots, you may forget what some snapshots contain. You can get a snaptshot's description using the Elasticsearch API. For example,

```bash
curl -XGET localhost:9200/_snapshot/test_backup/snapshot_1
```

returns

```json
{"snapshots":[
    {"snapshot":"snapshot_1",
    "uuid":"WlSjvJwHRh-xlAny7zeW3w",
    "version_id":6.80399,
    "version":"6.8.2",
    "indices":["liferay-20099","liferay-0","liferay-47206"],
    "state":"SUCCESS",
    "start_time":"2018-08-15T21:40:17.261Z",
    "start_time_in_millis":1534369217261,
    "end_time":"2018-08-15T21:40:17.482Z",
    "end_time_in_millis":1534369217482,
    "duration_in_millis":221,
    "failures":[],
    "shards":{
        "total":3,
        "failed":0,
        "successful":3
        
        }
    }
]}
```

The snapshot information includes the time range of the indexes.

If you want to discard a snapshot, use the `DELETE` command.

```bash
curl -XDELETE localhost:9200/_snapshot/test_backup/snapshot_1
```

Including all indexes in a snapshot can consume a lot of time and storage. If you start creating a snapshot by mistake (for example, wanted to filter on specific indexes but included all indexes) you can cancel snapshot processing using a `DELETE` command. By deleting the snapshot by name, the snapshot process terminates and the partial snapshot is removed from the repository.

## Test Restoring from the Snapshot

If a catastrophic failure occurs, what good is a snapshot if you can't [restore your search indexes](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshots-restore-snapshot.html) from it? Use the `_restore` API to restore all the snapshot's indexes:

```bash
curl -XPOST localhost:9200/_snapshot/test_backup/snapshot_1/_restore
```

To restore specific indexes, use the `indices` option, and rename the indexes using the `rename_pattern` and `rename_replacement` options:

```bash
curl -XPOST
localhost:9200/_snapshot/test_backup/snapshot_1/_restore
{
    "indices": "liferay-20116",
    "rename_pattern": "liferayindex_(.+)",
    "rename_replacement": "restored_liferayindex_$1"
}
```

This restores only the index named `liferay-20116index_1` from the snapshot. The `rename...` settings specify to replace the beginning `liferayindex_` with `restored_liferayindex_`, so `liferay-20116index_1` becomes `restored_liferay-20116index_1`.

As with the canceling a snapshot process, you can use the `DELETE` command to cancel an errant restore process:

```bash
curl -XDELETE localhost:9200/restored_liferay-20116index_3
```

Nobody likes catastrophic failure on a production system, but Elasticsearch's API for taking snapshots and restoring indexes can help you rest easy knowing that your search cluster can be restored if disaster strikes. For more details and options, read Elastic's [Snapshot and Restore documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshot-restore.html).

## Backing up and Restoring Search Tuning Indexes

Creating a snapshot of your Elasticsearch indexes is highly recommended, especially for indexes that act as the primary storage format: for example, the Search Tuning features ([Synonym Sets](../../../search_administration_and_tuning.rst) and [Result Rankings](../../../search_administration_and_tuning.rst)). There are no records for these applications in the database.

You can use Elasticsearch's [snapshot and restore](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshot-restore.html) feature to back up and restore the Search Tuning indexes.

1. Create a folder called `elasticsearch_local_backup` somewhere in the system. Make sure Elasticsearch has read and write access tothe folder (e.g., `/path/to/elasticsearch_local_backup`).

1. Add 

    ```yaml
    path.repo: [ "/path/to/elasticsearch_local_backup" ]
    ```

   to the `elasticsearch.yml` for [all master and data nodes](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshots-register-repository.html#snapshots-filesystem-repository) in the Elasticsearch cluster.

1. Restart all Elasticsearch nodes.

1. [Register the snapshot repository](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshots-register-repository.html). You can run the following `snapshot` API request (for example through the Dev Tools console in Kibana):

    ```json
    PUT /_snapshot/elasticsearch_local_backup
    {
      "type": "fs",
      "settings": {
        "location": "/path/to/elasticsearch_local_backup"
      }
    }
    ```

1. [Create a snapshot](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshots-take-snapshot.html):

    ```json
    PUT /_snapshot/elasticsearch_local_backup/snapshot1?wait_for_completion=true
    {
      "indices": "liferay-search-tuning*",
      "ignore_unavailable": true,
      "include_global_state": false
    }
    ```

    If you want to create a snapshot for all Liferay indexes, you can use `"indices": "liferay*,workflow-metrics*"` instead.

1. To [restore](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/snapshots-restore-snapshot.html) specific indexes from a snapshot using a different name, run a `restore` API call similar to this:

    ```json
    POST /_snapshot/elasticsearch_local_backup/snapshot1/_restore
    {
      "indices": "liferay-20101-search-tuning-synonyms,liferay-20101-search-tuning-rankings",
      "ignore_unavailable": true,
      "include_global_state": false,
      "rename_pattern": "(.+)",
      "rename_replacement": "restored_$1",
      "include_aliases": false
    }
    ```

   where `indices` sets the snapshotted index names to restore from. The indexes from the above call would be restored as `restored_liferay-20101-search-tuning-rankings` and `restored_liferay-20101-search-tuning-synonyms`, following the `rename_pattern` and `rename_replacement` regular expressions.

If you've added Synonym Sets or Results Rankings while running in Sidecar/Embedded mode, you'll see these search tunings disappear once you configure a Remote mode connection to Elasticsearch 7 and perform a full reindex.

To restore your existing _Search Tuning_ index documents, you can use the [Reindex API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-reindex.html#docs-reindex) of Elasticsearch, like this:

```json
   POST _reindex/
   {
     "dest": {
       "index": "liferay-20101-search-tuning-synonyms"
     },
     "source": {
       "index": "restored_liferay-20101-search-tuning-synonyms"
     }
   }
```

```tip::
   It's convenient to create and manage snapshots via the `Kibana 7.x UI <https://www.elastic.co/guide/en/kibana/7.x/snapshot-repositories.html>`__.
```

### Search Tuning Index Names

The out-of-the-box Search Tuning index names depend on your Liferay version and patch level:

| Liferay Version and Patch | Search Tuning Indexes |
| ------------------------- | --------------------- |
| Liferay DXP 7.2 SP2/FP5 and below| `liferay-search-tuning-rankings`<br />`liferay-search-tuning-synonyms-liferay-<companyId>` |
| Liferay DXP 7.2 SP3/FP8 and above | `liferay-<companyId>-search-tuning-rankings`<br />`liferay-<companyId>-search-tuning-synonyms` |
| Liferay DXP 7.3, all patches  | `liferay-<companyId>-search-tuning-rankings`<br />`liferay-<companyId>-search-tuning-synonyms` |

The `<companyId>` (e.g., `20101`) belongs to a given `Company` record in the database. It is displayed as _Instance ID_ in the UI and represents a [Virtual Instance](../../../../system-administration/configuring-liferay/virtual-instances/understanding-virtual-instances.md).

## What's Next

If you are [upgrading Elasticsearch](./upgrading-to-elasticsearch-79.md), you can do that now. 

## Additional Information

[Search Administration and Tuning](../../../search_administration_and_tuning.md)