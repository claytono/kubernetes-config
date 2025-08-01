"use strict";

// If you find yourself always using the same command-line flag, you can set
// it here as a default.
Object.defineProperty(exports, "__esModule", { value: true });
module.exports = {
    /**
     * Pause at least this much in between each search. Higher is safer.
     * It is not recommended to set this to less than 2 seconds.
     */
    delay: 30,
    /**
     * List of Torznab URLs.
     * For Jackett, click "Copy RSS feed"
     * For Prowlarr, click on the indexer name and copy the Torznab Url, then append "?apikey=YOUR_PROWLARR_API_KEY"
     * Wrap each URL in quotation marks, and separate them with commas, and surround the entire set in brackets.
     */
    torznab: [
        process.env.PROWLARR_URL_1,
        process.env.PROWLARR_URL_2,
        process.env.PROWLARR_URL_3,
        process.env.PROWLARR_URL_4
    ].filter(Boolean),
    /**
     * To search with downloaded data, you can pass in directories to your downloaded torrent
     * data to find matches rather using the torrent files themselves for matching.
     *
     * If enabled, this needs to be surrounded by brackets. Windows users will need to use
     * double backslash in all paths in this config.
     * e.g.
     * 		dataDirs: ["/path/here"],
     * 		dataDirs: ["/path/here", "/other/path/here"],
     * 		dataDirs: ["C:\\My Data\\Downloads"]
     */
    dataDirs: [
        "/downloads/qbittorrent/completed",
        "/downloads/transmission/complete",
    ],
    /**
     * Determines flexibility of naming during matching. "safe" will allow only perfect name matches
     * using the standard matching algorithm. "risky" uses filesize as its only comparison point.
     * Options: "safe", "risky"
     */
    matchMode: "safe",
    /**
     * Defines what category torrents injected by data-based matching should use.
     * Default is "cross-seed-data"
     */
    dataCategory: undefined,
    /**
     * List of torrent clients for injection and matching.
     * Format: ["qbittorrent:http://username:password@host:port"]
     * You can use environment variables for secrets.
     */
    torrentClients: [
        `qbittorrent:${process.env.QBITTORRENT_URL}`
    ],
    /**
     * List of directories where cross-seed will create links to scanned files.
     */
    linkDirs: ["/downloads/qbittorrent/cross-seeds"],
    /**
     * cross-seed will use links of this type to inject data-based matches into your client.
     * Only relevant if dataDirs is specified.
     * Options: "symlink", "hardlink"
     */
    linkType: "hardlink",
    /**
     * Whether to skip recheck in Qbittorrent. If using "risky" matchMode it is HIGHLY
     * recommended to set this to false.
     * Only applies to data based matches.
     */
    skipRecheck: false,
    /**
     * Determines how deep into the specified dataDirs to go to generate new searchees.
     * Setting this to higher values will result in more searchees and more API hits to
     * your indexers.
     */
    maxDataDepth: 2,
    /**
     * Directory containing .torrent files.
     * For qBittorrent, this is BT_Backup
     * For rtorrent, this is your session directory
     * 		as configured in your .rtorrent.rc file.
     * For Deluge, this is ~/.config/deluge/state.
     * For Transmission, this would be ~/.config/transmission/torrents
     *
     * Don't change this for Docker.
     * Instead set the volume mapping on your docker container.
     */
    torrentDir: "/torrents",
    /**
     * Where to put the torrent files that cross-seed finds for you.
     * Don't change this for Docker.
     * Instead set the volume mapping on your docker container.
     */
    outputDir: "/cross-seeds",
    /**
     * Whether to search for all episode torrents, including those from season packs. This option overrides includeSingleEpisodes.
     */
    includeEpisodes: false,
    /**
     * Whether to include single episode torrents in the search (not from season packs).
     * Like `includeEpisodes` but slightly more restrictive.
     */
    includeSingleEpisodes: false,
    /**
     * Include torrents which contain non-video files
     * This option does not override includeEpisodes or includeSingleEpisodes.
     *
     * To search for everything except episodes, use (includeEpisodes: false, includeSingleEpisodes: false, includeNonVideos: true)
     * To search for everything including episodes, use (includeEpisodes: true, includeNonVideos: true)
     * To search for everything except season pack episodes (data-based)
     *    use (includeEpisodes: false, includeSingleEpisodes: true, includeNonVideos: true)
     */
    includeNonVideos: false,
    /**
     * fuzzy size match threshold
     * decimal value (0.02 = 2%)
     */
    fuzzySizeThreshold: 0.02,
    /**
     * Exclude torrents first seen more than this long ago.
     * Format: https://github.com/vercel/ms
     * Examples:
     * "10min"
     * "2w"
     * "3 days"
     */
    excludeOlder: "3w",
    /**
     * Exclude torrents which have been searched
     * more recently than this long ago.
     * Examples:
     * "10min"
     * "2w"
     * "3 days"
     */
    excludeRecentSearch: "9d",
    /**
     * With "inject" you need to set up one of the below clients.
     * Options: "save", "inject"
     */
    action: "inject",
    /**
     * qBittorrent and Deluge specific
     * Whether to inject using the same labels/categories as the original torrent.
     * qBittorrent: This will apply the category's save path
     * Example: if you have a label/category called "Movies",
     * this will automatically inject cross-seeds to "Movies.cross-seed"
     */
    duplicateCategories: true,
    /**
     * cross-seed will send POST requests to this url
     * with a JSON payload of { title, body }.
     * Conforms to the caronc/apprise REST API.
     */
    notificationWebhookUrl: undefined,
    /**
     * Listen on a custom port.
     */
    port: 2468,
    /**
     * Bind to a specific host address.
     * Example: "127.0.0.1"
     * Default is "0.0.0.0"
     */
    host: undefined,
    /**
     * Whether to require authentication for API.
     * Run the command `cross-seed api-key` to find your api key.
     * Keys can be provided in an X-Api-Key HTTP header or a query param.
     */
    apiAuth: true,
    /**
     * Run rss scans on a schedule. Format: https://github.com/vercel/ms
     * Set to undefined or null to disable. Minimum of 10 minutes.
     * Examples:
     * "10min"
     * "2w"
     * "3 days"
     */
    rssCadence: undefined,
    /**
     * Run searches on a schedule. Format: https://github.com/vercel/ms
     * Set to undefined or null to disable. Minimum of 1 day.
     * If you have RSS enabled, you won't need this to run often (2+ weeks recommended)
     * Examples:
     * "10min"
     * "2w"
     * "3 days"
     */
    searchCadence: "3d",
    /**
     * Fail snatch requests that haven't responded after this long.
     * Set to null for an infinite timeout.
     * Format: https://github.com/vercel/ms
     * Examples:
     * "30sec"
     * "10s"
     * "1min"
     * null
     */
    snatchTimeout: undefined,
    /**
     * Fail search requests that haven't responded after this long.
     * Set to null for an infinite timeout.
     * Format: https://github.com/vercel/ms
     * Examples:
     * "30sec"
     * "10s"
     * "1min"
     * null
     */
    searchTimeout: undefined,
    /**
     * The number of searches to be done before it stops.
     * Combine this with "excludeRecentSearch" and "searchCadence" to smooth long-term API usage patterns.
     * Default is no limit.
     */
    searchLimit: undefined,
};
