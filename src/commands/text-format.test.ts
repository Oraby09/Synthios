import { describe, expect, it } from "vitest";
import { shortenText } from "./text-format.js";

describe("shortenText", () => {
  it("returns original text when it fits", () => {
    expect(shortenText("synthios", 16)).toBe("synthios");
  });

  it("truncates and appends ellipsis when over limit", () => {
    expect(shortenText("synthios-status-output", 10)).toBe("synthios-…");
  });

  it("counts multi-byte characters correctly", () => {
    expect(shortenText("hello🙂world", 7)).toBe("hello🙂…");
  });
});
