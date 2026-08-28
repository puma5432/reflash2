from __future__ import annotations

import numpy as np

from ssf2_rl.data.episode import Episode
from ssf2_rl.policy.observation import OBS_DIM


def _frame() -> dict:
    return {
        "frame": 250,
        "paused": 0,
        "ended": 0,
        "chars": [
            {
                "id": 1, "x": 120.0, "y": -30.0, "nxs": 4.0, "nys": -2.0,
                "facing": 1, "damage": 85.0, "stocks": 3, "ground": 1,
                "jumpCount": 1, "shieldPower": 70.0, "shielding": 0,
                "hitstun": 0, "atkFrame": 1, "atkExec": 12.0, "hanging": 0,
                "dead": 0, "controls": 32,
            },
            {
                "id": 2, "x": -80.0, "y": 10.0, "nxs": -3.0, "nys": 1.0,
                "facing": 0, "damage": 30.0, "stocks": 4, "ground": 0,
                "jumpCount": 2, "shieldPower": 100.0, "shielding": 1,
                "hitstun": 1, "atkFrame": 0, "atkExec": 0.0, "hanging": 0,
                "dead": 0, "controls": 0,
            },
        ],
    }


def test_bc_dataset_can_return_raw_engine_observations() -> None:
    episode = Episode([_frame()])

    raw_obs, actions = episode.to_bc_dataset(player_id=1, normalize=False)
    normalized_obs, _ = episode.to_bc_dataset(player_id=1, normalize=True)

    assert raw_obs.shape == (1, OBS_DIM)
    assert raw_obs.dtype == np.float32
    assert raw_obs[0, :6].tolist() == [120.0, -30.0, 4.0, -2.0, 1.0, 85.0]
    np.testing.assert_allclose(
        raw_obs[0, 32:38],
        [-200.0, 40.0, np.hypot(-200.0, 40.0), 0.0, 250.0, 0.0],
    )
    assert actions.tolist() == [32]
    assert not np.array_equal(raw_obs, normalized_obs)