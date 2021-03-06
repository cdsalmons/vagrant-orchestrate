0.8.0 (November 23rd, 2015)

  - Add an action as part of the push command that will change ownership of all synced folders to the configured user to avoid permission conflicts.
    - Added config.orchestrate.take_synced_file_ownership and documented in docs/config.md (default is true)
    - Should have no impact on Windows systems, since `chown` is filtered out by the winrm communicator filter

0.7.2 (September 25th, 2015)

  - Include windows guest directive on winrm template to correct issues with incorrect
  guest identification.

0.7.1 (August 13th, 2015)

  - Add configuration option for disable_commit_guard, which when set to true will silence
  the message about uncommitted files. Use at your own risk.

0.7.0 (July 15th, 2015)

  - Add support for tracking deployments with [deployment-tracker](https://github.com/Cimpress-MCP/deployment-tracker).
  Add configuration option `config.orchestrate.tracker_host = 'deploymenttracker.mydomain.com'`

0.6.5 (June 27th, 2015)

  - Split GIT_BRANCH environment variable on slash and take the last element, since
  that is how Jenkins is providing it. [#40](https://github.com/Cimpress-MCP/vagrant-orchestrate/issues/40)

0.6.4 (June 26th, 2015)

  - Add common ignores to the `.gitignore` file in the root of the repo unless
  `--no-git` is specified. Fixes [#28](https://github.com/Cimpress-MCP/vagrant-orchestrate/issues/28)

0.6.3 (May 26th, 2015)

  - Extract the `required_plugins` definition and installation logic from the
  `Vagrantfile` to a new `.vagrantplugins` file per https://github.com/mitchellh/vagrant/issues/4347
  - Change required_plugins from array to hash[plugin-name] = {options}. This allows specifying specific versions of plugins to be installed as well as alternate gem sources, which is useful for internally hosted gems.
  - Fall back to the Vagrant environment's `root_path` if the working directory is
  not a git repo. Fixes [#34](https://github.com/Cimpress-MCP/vagrant-orchestrate/issues/34)

0.6.2 (May 25th, 2015)

  - Change the implementation of the `RepoStatus.repo` method from relying on a
  remote named `origin` to using the state of the local file system. Thanks @rnowosielski
  for the bug report.

0.6.1 (May 23rd, 2015)

  - Change the credentials manager to add the `smb_username` and `smb_password` to
  the synced folders for a machine if the communicator is `winrm`. For Windows,
  this means only a single credential prompt for both machine authentication and
  SMB auth.

0.6.0 (May 15th, 2015)

  - Refactor the push command to compose middleware actions rather than performing
  a bunch of work in the command itself. This means that a push using the `parallel`
  strategy will truly be parallel per box, as opposed to the old implementation where
  the `up`, `provision`, `upload_stats`, and `destroy` phases would each happen in
  parallel, but the phases would be done in series.
  - Change the `vagrant orchestrate status` command so that it will run in parallel.
  - Add `vagrant-orchestrate` as a default required plugin. Someone will have to
  install it "by hand" to access the init functionality, but other users pulling
  down a repo with a committed Vagrantfile will not, making each repo more self-contained.

0.5.3 (May 13th, 2015)

  - Fix a bug where the VAGRANT_ORCHESTRATE_USERNAME and VAGRANT_ORCHESTRATE_PASSWORD
  environment variable overrides weren't being read properly. The bug was repro'd
  on a Windows environment.

0.5.2 (May 8th, 2015)

  - Add the `--no-provision` option to the `orchestrate push` command. Useful for
  first timers to gain confidence in using the tool or to be able to just reboot servers.
  - Move the `winrm.transport = :sspinegotiate` declaration from the config level
  to within the managed server section, allowing local Windows VMs to work again.
  - Change the default for --puppet-librarian-puppet to false, as it was impacting
  many Windows users.

0.5.1 (April 27th, 2015)

  - Also short circuit a push operation with an error message if there are untracked files.

0.5.0 (April 22, 2015)

  - Add guard_clean so that a push will fail if there are uncommitted files. Override with VAGRANT_ORCHESTRATE_NO_GUARD_CLEAN
  - Push a status file including git remote url, ref, user, and date on a successful provision to /var/status/vagrant_orchestrate (c:\programdata\vagrant_orchestrate)
  - Retrieve status using `vagrant orchestrate status`
