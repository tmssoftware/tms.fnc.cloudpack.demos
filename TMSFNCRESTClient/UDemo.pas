unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCloudBase, FMX.TMSFNCCustomComponent, FMX.TMSFNCRESTClient,
  FMX.Controls.Presentation, FMX.StdCtrls, Generics.Collections, FMX.Edit,
  FMX.Layouts, FMX.ListBox, FMX.Objects;

type
  TMovie = class(TPersistent)
  private
    FName: string;
    FImageUrl: string;
    FLanguage: string;
    FGenres: string;
  published
    property Name: string read FName write FName;
    property Language: string read FLanguage write FLanguage;
    property Genres: string read FGenres write FGenres;
    property ImageUrl: string read FImageUrl write FImageUrl;
  end;

  TMovies = class(TObjectList<TMovie>);

  TForm4 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    ListBox1: TListBox;
    Label1: TLabel;
    Image1: TImage;
    TMSFNCRESTClient1: TTMSFNCRESTClient;
    NameLbl: TLabel;
    GenresLbl: TLabel;
    LanguageLbl: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCRESTClient1RequestResponseRetrieved(Sender: TObject;
      ARequest: TTMSFNCRESTClientExecutedRequest; AResultString: string;
      AResultStream: TMemoryStream; AResultFile: string);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    movies: TMovies;
    procedure UpdateList;
    procedure DoGetMovieImage(AResponseStream: TMemoryStream);
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses
  JSON;

{$R *.fmx}

procedure TForm4.Button1Click(Sender: TObject);
begin
  TMSFNCRESTClient1.Request.ResultType := rrtString;
  TMSFNCRESTClient1.Request.Host := 'https://api.tvmaze.com';
  TMSFNCRESTClient1.Request.Path := '/search/shows';
  TMSFNCRESTClient1.Request.Query := 'q='+Edit1.Text;
  TMSFNCRESTClient1.ExecuteRequest;

  movies.Clear;
end;

procedure TForm4.DoGetMovieImage(AResponseStream: TMemoryStream);
begin
  Image1.Bitmap.LoadFromStream(AResponseStream);
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  movies := TMovies.Create;
end;

procedure TForm4.FormDestroy(Sender: TObject);
begin
  movies.Free;
end;

procedure TForm4.ListBox1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  if (Item.Data as TMovie).ImageUrl <> '' then
  begin
    TMSFNCRESTClient1.Request.Clear;
    TMSFNCRESTClient1.Request.ResultType := rrtStream;
    TMSFNCRESTClient1.Request.URL := (Item.Data as TMovie).ImageUrl;
    TMSFNCRESTClient1.ExecuteRequestWithResultStream(DoGetMovieImage);
  end;

  NameLbl.Text := movies[ListBox1.ItemIndex].Name;
  GenresLbl.Text := movies[ListBox1.ItemIndex].Genres;
  LanguageLbl.Text := movies[ListBox1.ItemIndex].Language;
end;

procedure TForm4.TMSFNCRESTClient1RequestResponseRetrieved(Sender: TObject; ARequest: TTMSFNCRESTClientExecutedRequest; AResultString: string; AResultStream: TMemoryStream; AResultFile: string);
var
  o, fo: TJSONValue;
  jv, jvv, jvvv: TJSONValue;
  ja, jaa: TJSONArray;
  I, K: Integer;
  m: TMovie;
begin
  if AResultString <> '' then
  begin
    Label1.Visible := False;

    o := TTMSFNCUtils.ParseJSON(AResultString);

    if Assigned(o) then
    begin
      try
        ja := o as TJSONArray;
        for I := 0 to TTMSFNCUtils.GetJSONArraySize(ja) - 1 do
        begin
          fo := TTMSFNCUtils.GetJSONArrayItem(ja, I);

          m := TMovie.Create;

          jv := TTMSFNCUtils.GetJSONValue(fo, 'show');
          if Assigned(jv) then
          begin
            jvv := TTMSFNCUtils.GetJSONValue(jv, 'name');
            if Assigned(jvv) then
              m.Name := TTMSFNCUtils.GetJSONProp(jv, 'name');

            jvv := TTMSFNCUtils.GetJSONValue(jv, 'language');
            if Assigned(jvv) then
              m.Language := TTMSFNCUtils.GetJSONProp(jv, 'language');

            jvv := TTMSFNCUtils.GetJSONValue(jv, 'genres');
            if Assigned(jvv) then
            begin
              jaa := jvv as TJSONArray;
              m.Genres := '';
              for K := 0 to TTMSFNCUtils.GetJSONArraySize(jaa) - 1 do
              begin
                if m.Genres <> '' then
                  m.Genres := m.Genres + ', ';
                m.Genres := m.Genres + TTMSFNCUtils.GetJSONArrayItem(jaa, K).Value;
              end;
            end;

            if m.Genres = '' then
            begin
              jvv := TTMSFNCUtils.GetJSONValue(jv, 'type');
              if Assigned(jvv) then
                m.Genres := TTMSFNCUtils.GetJSONProp(jv, 'type');
            end;

            jvv := TTMSFNCUtils.GetJSONValue(jv, 'image');
            if Assigned(jvv) then
            begin
              jvvv := TTMSFNCUtils.GetJSONValue(jvv, 'medium');
              if Assigned(jvvv) then
                m.ImageUrl := TTMSFNCUtils.GetJSONProp(jvv, 'medium');
            end;
          end;

          movies.Add(m);
        end;
      finally
        o.Free;
      end;
    end;
  end;

  UpdateList;
end;

procedure TForm4.UpdateList;
var
  I: Integer;
begin
  ListBox1.Items.Clear;
  ListBox1.BeginUpdate;
  for I := 0 to movies.Count - 1 do
  begin
    ListBox1.Items.AddObject(movies[I].Name, movies[I]);
  end;
  ListBox1.EndUpdate;
end;

end.

