from __future__ import annotations

import json
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import lab


class StarterContractTests(unittest.TestCase):
    def test_activity_allowlist_and_version_agree(self) -> None:
        starter = json.loads((ROOT / "starter.json").read_text(encoding="utf-8"))
        self.assertEqual(tuple(starter["activities"]), lab.SCENARIOS)
        self.assertEqual(starter["starterVersion"], lab.STARTER_VERSION)

    def test_source_digest_is_stable_and_complete(self) -> None:
        self.assertRegex(lab.source_digest(), r"^[a-f0-9]{64}$")

    def test_forbidden_course_assets_are_absent(self) -> None:
        forbidden_extensions = {".ppt", ".pptx", ".pdf"}
        self.assertFalse([path for path in ROOT.rglob("*") if path.suffix.lower() in forbidden_extensions])


if __name__ == "__main__":
    unittest.main()
