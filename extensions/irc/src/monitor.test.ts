import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#synthios",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#synthios",
      rawTarget: "#synthios",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "synthios-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "synthios-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "synthios-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "synthios-bot",
      rawTarget: "synthios-bot",
    });
  });
});
