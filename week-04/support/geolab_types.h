#ifndef WEEK04_GEOLAB_TYPES_H
#define WEEK04_GEOLAB_TYPES_H
/* Supplied types and limits; no exercise answer lives here. */
#include <stddef.h>
#include <stdint.h>

/* The week-1 record type: an identifier and a position in degrees. */
typedef struct { uint64_t id; double lat_deg; double lon_deg; } GeoPoint;

/* Every status used this week. PARSE_OK is 0 so that a status can be tested as "no error". */
typedef enum {
    PARSE_OK = 0,
    PARSE_EMPTY,          /* an empty line */
    PARSE_FIELD_COUNT,    /* not exactly two commas */
    PARSE_BAD_ID,         /* identifier grammar, leading zero, > 20 digits, or > UINT64_MAX */
    PARSE_BAD_LAT,        /* latitude grammar, or the non-canonical -0.000000 */
    PARSE_LAT_RANGE,      /* latitude grammar is valid but the magnitude exceeds 90 */
    PARSE_BAD_LON,
    PARSE_LON_RANGE,      /* longitude grammar is valid but the magnitude exceeds 180 */
    PARSE_LINE_TOO_LONG,  /* loader: more than GEOLAB_MAX_LINE characters before the newline */
    PARSE_MISSING_HEADER, /* loader: the file is empty */
    PARSE_BAD_HEADER,     /* loader: the first line is not exactly the header */
    PARSE_TOO_MANY_ROWS,  /* loader: more than GEOLAB_MAX_ROWS rows */
    PARSE_NUL_BYTE,       /* loader: a NUL byte (a C string cannot hold one) */
    PARSE_OPEN_ERROR,     /* loader: the file could not be opened */
    PARSE_IO_ERROR,       /* loader: a read error, or a failing fclose */
    PARSE_OUT_OF_MEMORY,  /* loader: allocation failed or the byte count would overflow */
    PARSE_INVALID_ARGUMENT /* parser: NULL input line or output pointer */
} ParseStatus;

#ifndef GEOLAB_MAX_ROWS
#define GEOLAB_MAX_ROWS 1000000u /* course cap; tests lower it with -D */
#endif
#define GEOLAB_MAX_LINE 127      /* characters per line, excluding the newline; longest generated line is 43 */
#define GEOLAB_HEADER "id,lat_deg,lon_deg"

static inline const char *parse_status_name(ParseStatus s)
{
    switch (s) {
    case PARSE_OK: return "PARSE_OK";
    case PARSE_EMPTY: return "PARSE_EMPTY";
    case PARSE_FIELD_COUNT: return "PARSE_FIELD_COUNT";
    case PARSE_BAD_ID: return "PARSE_BAD_ID";
    case PARSE_BAD_LAT: return "PARSE_BAD_LAT";
    case PARSE_LAT_RANGE: return "PARSE_LAT_RANGE";
    case PARSE_BAD_LON: return "PARSE_BAD_LON";
    case PARSE_LON_RANGE: return "PARSE_LON_RANGE";
    case PARSE_LINE_TOO_LONG: return "PARSE_LINE_TOO_LONG";
    case PARSE_MISSING_HEADER: return "PARSE_MISSING_HEADER";
    case PARSE_BAD_HEADER: return "PARSE_BAD_HEADER";
    case PARSE_TOO_MANY_ROWS: return "PARSE_TOO_MANY_ROWS";
    case PARSE_NUL_BYTE: return "PARSE_NUL_BYTE";
    case PARSE_OPEN_ERROR: return "PARSE_OPEN_ERROR";
    case PARSE_IO_ERROR: return "PARSE_IO_ERROR";
    case PARSE_OUT_OF_MEMORY: return "PARSE_OUT_OF_MEMORY";
    case PARSE_INVALID_ARGUMENT: return "PARSE_INVALID_ARGUMENT";
    }
    return "PARSE_UNKNOWN";
}
#endif
