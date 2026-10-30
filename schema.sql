-- ============================================================================
-- Network Intrusion Detection System - Database Schema
-- Dataset: NSL-KDD, 41 traffic features + label + difficulty score, 100K+ records
-- ============================================================================

DROP TABLE IF EXISTS network_traffic;

CREATE TABLE network_traffic (
    id                              INTEGER PRIMARY KEY AUTOINCREMENT,
    duration                        INTEGER,
    protocol_type                   TEXT,
    service                         TEXT,
    flag                            TEXT,
    src_bytes                       INTEGER,
    dst_bytes                       INTEGER,
    land                            INTEGER,
    wrong_fragment                  INTEGER,
    urgent                          INTEGER,
    hot                             INTEGER,
    num_failed_logins               INTEGER,
    logged_in                       INTEGER,
    num_compromised                 INTEGER,
    root_shell                      INTEGER,
    su_attempted                    INTEGER,
    num_root                        INTEGER,
    num_file_creations              INTEGER,
    num_shells                      INTEGER,
    num_access_files                INTEGER,
    num_outbound_cmds               INTEGER,
    is_host_login                   INTEGER,
    is_guest_login                  INTEGER,
    count                           INTEGER,
    srv_count                       INTEGER,
    serror_rate                     REAL,
    srv_serror_rate                 REAL,
    rerror_rate                     REAL,
    srv_rerror_rate                 REAL,
    same_srv_rate                   REAL,
    diff_srv_rate                   REAL,
    srv_diff_host_rate              REAL,
    dst_host_count                  INTEGER,
    dst_host_srv_count              INTEGER,
    dst_host_same_srv_rate          REAL,
    dst_host_diff_srv_rate          REAL,
    dst_host_same_src_port_rate     REAL,
    dst_host_srv_diff_host_rate     REAL,
    dst_host_serror_rate            REAL,
    dst_host_srv_serror_rate        REAL,
    dst_host_rerror_rate            REAL,
    dst_host_srv_rerror_rate        REAL,
    label                           TEXT,
    attack_category                 TEXT,
    difficulty_level                INTEGER,
    dataset_split                   TEXT
);

CREATE INDEX idx_traffic_label            ON network_traffic (label);
CREATE INDEX idx_traffic_attack_category  ON network_traffic (attack_category);
CREATE INDEX idx_traffic_protocol         ON network_traffic (protocol_type);
CREATE INDEX idx_traffic_split            ON network_traffic (dataset_split);

DROP TABLE IF EXISTS attack_category_map;

CREATE TABLE attack_category_map (
    label            TEXT PRIMARY KEY,
    attack_category  TEXT NOT NULL
);