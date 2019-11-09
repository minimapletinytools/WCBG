# Realtime Games
So far we've only proposed games that use turn-based interfaces (though time for each turn may be quite small)

Is it possible to apply this framework towards realtime action based games in a decentralized setting?

Using a ballot based BFT consensus (final transaction set taken to be union of all BFT agreed transaction sets sorted by hash) with small-ish sets of participants, pings of ~100-500ms seem reasonable. It vulnerable to reordering attacks (requiring PoW) which can be partially mitigated by design.

Leader based BFT consensus protocols like PaLa would be faster (or hybrid consensus Thunderella which is even faster) are vulnerable to short term censorship which can be very problematic.

Transparent and globally known state makes hiding information impossible and limits design to games with symmetric information only. This can be worked around using commit reveal schemes which incurs latency or ZK snarks which are hard to implement.

Another solution is partial centralization with trusted servers--either permissioned or voted in by players. The former looks centralized and it is hard or impossible to argue for security in the latter case.

Bots are indifferent to realtime our turn based mechanics. If the game is easy to solve, equillibrium state will involve many competing bots. We expect that top player skill will outcompete whatever a bot can do, especially for games involving many agents.
