# negdiv.sh

**Shell script for removing the orange mask on color negatives and inverting them to positive**

This is Antti Penttala's script, as originally pusblished with his article **“The Fastest And Easiest Method For Removing The Orange Mask In Photoshop”** on July 31, 2015. It seems howewer, that the [original article](http://www.penttala.fi/blog/the-fastest-and-easiest-method-for-removing-the-orange-mask-in-photoshop/) is not available any longer; One may try a [snapshot](https://web.archive.org/web/20190101000000*/http://www.penttala.fi/blog/the-fastest-and-easiest-method-for-removing-the-orange-mask-in-photoshop/) over on [archive.org.](https://web.archive.org/web/20190101000000*/http://www.penttala.fi/blog/the-fastest-and-easiest-method-for-removing-the-orange-mask-in-photoshop/)

This repo intends to make this script available via [homebrew](https://brew.sh/), the missing package manager for macOS.



## Approaching the orange mask

**The idea of Antti Penttala's script is to “subtract” the orange color from the typically orange-tinted color negative image.** The script first internally resizes a **mask image** (blank piece of film) to 1×1 pixels, resulting in an “average orange”. It then *divides* the color values in the **frame image** by this average orange. After that, the image will be inverted (negated). The resulting positive image is stored with the same filename, but prefixed with **pos_** .

  

## Example

This removes the *orange* found in **mask.tiff** from **myphoto.tiff** and inverts the image to positive. The result image can be found under **pos_myphoto.tiff**

```bash
$ negdiv mask.tiff myphoto.tiff
$ ls

myphoto.tiff
pos_myphoto.tiff
```



## Installation

- **Linux** and **macOS** users store the script somewhere and make it executable: `chmod +x negdiv.sh`
- If not stored inside `~/bin`, add the directory location to your `$PATH` variable.
- Make sure [ImageMagick.](http://www.imagemagick.org) is installed. 




## Usage

```bash
$ negdiv [options ...] maskfile framefile ...
```

### General options

Option    | Description
:---------|:----------------------------
  -a      | Use [autotone](http://www.fmwconcepts.com/imagemagick/autotone/index.php) script by Fred Weinhaus to finalize the image
  -j      | Output in jpg format
  -p path | Output to path instead of current directory
  -q      | Keep quiet


### Autotone options


The *negdiv.sh* script allows to pass its output to Fred Weinhaus' [autotone](http://www.fmwconcepts.com/imagemagick/autotone/index.php) script which is part of [Fred's ImageMagick Scripts](www.fmwconcepts.com/imagemagick/). They are available free of charge for non-commercial use, ONLY.

However, these options apply when `-a` is selected:

Option    | Description
:---------|:----------------------------
  -n none |  Do not reduce noise
  -n auto |  Use autotone defaults for noise reduction instead of *negdiv* defaults
  -n 2.0  |  Pass the float value to *autotone* for noise reduction parameter
  -s none |  Do not sharpen
  -s auto |  Use *autotone* defaults for sharpening instead of *negdiv* defaults
  -s 3.0  |  Pass the float value to *autotone* for sharpening parameter  


## Legal notes

**License:** [GNU General Public License v2.0](https://choosealicense.com/licenses/gpl-2.0/)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.



