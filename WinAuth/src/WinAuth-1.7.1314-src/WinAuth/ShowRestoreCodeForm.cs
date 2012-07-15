﻿/*
 * Copyright (C) 2010 Colin Mackie.
 * This software is distributed under the terms of the GNU General Public License.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Threading;
using System.Windows.Forms;

namespace WindowsAuthenticator
{
	/// <summary>
	/// Form display initialization confirmation.
	/// </summary>
	public partial class ShowRestoreCodeForm : Form
	{
		/// <summary>
		/// Current authenticator
		/// </summary>
		public Authenticator Authenticator { get; set; }

		/// <summary>
		/// Create a new form
		/// </summary>
		public ShowRestoreCodeForm()
		{
			InitializeComponent();
		}

		/// <summary>
		/// Click OK button to close form
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnOK_Click(object sender, EventArgs e)
		{
			this.Close();
		}

		/// <summary>
		/// Form loaded event
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void ShowRestoreCodeForm_Load(object sender, EventArgs e)
		{
			this.serialNumberField.SecretMode = true;
			this.serialNumberField.Text = Authenticator.Serial;
			this.restoreCodeField.SecretMode = true;
			this.restoreCodeField.Text = Authenticator.RestoreCode;

			// if needed start a background thread to verify the restore code
			if (this.Authenticator.RestoreCodeVerified == false)
			{
				BackgroundWorker verify = new BackgroundWorker();
				verify.DoWork += new DoWorkEventHandler(VerifyRestoreCode);
				verify.RunWorkerCompleted += new RunWorkerCompletedEventHandler(VerifyRestoreCodeCompleted);
				verify.RunWorkerAsync(this.Authenticator);
			}
		}

		/// <summary>
		/// Event when verification is completed
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		void VerifyRestoreCodeCompleted(object sender, RunWorkerCompletedEventArgs e)
		{
			string message = e.Result as string;
			if (string.IsNullOrEmpty(message) == false)
			{
				MessageBox.Show(this, message, WinAuth.APPLICATION_NAME, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
			}
		}

		/// <summary>
		/// Perform a verification of the restore code in the background by checking it with the servers
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		void VerifyRestoreCode(object sender, DoWorkEventArgs e)
		{
			Authenticator auth = e.Argument as Authenticator;

			// check if this authenticator is too old to be restored
			try
			{
				Authenticator testrestore = new Authenticator();
				testrestore.Restore(auth.Serial, auth.RestoreCode);
				auth.RestoreCodeVerified = true;
				e.Result = null;
			}
			catch (InvalidRestoreCodeException)
			{
				e.Result = "This authenticator was created before the restore capability existed and so the restore code will not work.\n\n"
						+ "You will need to remove this authenticator from your Battle.net account and create a new one.";
			}
			catch (InvalidRestoreResponseException)
			{
				// ignore the validation if servers are down
			}
			catch (Exception ex2)
			{
				e.Result = "Oops. An error (" + ex2.Message + ") occured whilst validating your restore code."
						+ "Please log a ticket at http://code.google.com/p/winauth so we can fix this.";
			}
		}

	}
}
